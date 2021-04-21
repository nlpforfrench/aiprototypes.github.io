# Deploying Django app on Ubuntu at digitalocean + SSL certificate 🇬🇧

[Xiaoou Wang](https://xiaoouwang.github.io)

It can be quite frustrating/challenging for django newbies to deploy their app because a bunch of new concepts should be known in order to play the game with confidence. This tutorial gives you all the basics and further reference. The structure of the project can be seen in the following screenshot: the project `my_blog` is itself located in the `blog` folder.

![](https://i.imgur.com/FglTVf6.png)

## Deployment in a nutshell

You need
* a web server (often Nginx or apache) to handle http requests
* an application server called gunicorn to serve your django app (the middle layer)
* a django app
* a database management system (often mysql or postgresql) to store information.
* sometimes a firewall system to block some requests

## Step by step

### A server/droplet on digitalocean with often a Linux system as Ubuntu

![](https://i.imgur.com/a0Lf3Xp.png)

Note, some tutorials said that a password would be sent to your email. This is outdated, remember, for an easy start, to choose the password method and set your password as follows. The 5$ plan is largely sufficient for personal use.

![](https://i.imgur.com/6AYEhq2.png)

### A regular user with some root privileges

For our purpose you just need the following steps:

First connect to the server using ssh, on Mac you are good to go already on Windows you can use `PuTTy`, see the reference

> ref https://www.digitalocean.com/docs/droplets/how-to/connect-with-ssh/

```bash
ssh root@your_server_ip
```

The server ip can be seen here

![](https://i.imgur.com/UiJgLGx.png)

Then add a regular user with root privileges

> ref https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04

```bash
adduser sammy # add a user
usermod -aG sudo sammy # give sammy root privileges
```
Now log out and log in this regular user

```bash
ssh sammy@your_server_ip
```

### Update apt-get to install the most recent packages

Here we install pip, postgresql (database tool) and nginx (web server). In simple terms, `nginx` is the server who takes http requests, another common server is `apache`.

```bash
sudo apt-get update
sudo apt-get install python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx
```

### Set up the database

First log into postgresql

```bash
sudo -u postgres psql
```

Then create a database, user and password.

```bash
CREATE DATABASE yourproject; # replace yourproject with your database name
CREATE USER myprojectuser WITH PASSWORD 'password'; # set username and password
ALTER ROLE myprojectuser SET client_encoding TO 'utf8';
ALTER ROLE myprojectuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE myprojectuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE myproject TO myprojectuser;
\q # quit
```

### Add the database setting set up in step 4 into your `Settings.py` on your local computer

```python
if DEBUG:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
        }
    }
else:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql_psycopg2',
            'NAME': 'yourdatabasename',
            'USER': 'yourdatabaseuser',
            'PASSWORD': 'yourdatabasepassword',
            'HOST': 'localhost',
            'PORT': '',
        }
    }
```

### Set up a virtual environment for Python

```bash
sudo -H pip3 install --upgrade pip
sudo -H pip3 install virtualenv
```

Since my website's source code is hosted on github I will use git to clone the project into the folder `blog`.

Run `pip freeze > requirements.txt` on your local computer then use `pip install -r requirements.txt` to install dependencies for your app. Remember to run `pip install psycopg2-binary gunicorn` to have these two packages in the `requirements.txt`.

Also add your service ip in `ALLOWED_HOSTS` of your global`settings.py`

![](https://i.imgur.com/fipeWqq.png)

Update your git repository, be sure to have uploaded the most recent `requirements.txt`. Then get the repository on the server by running:

```bash
git clone yourrepository blog
cd blog
git config credential.helper store # remember your username and password
```

And then create a virtualenv named `env` and activate it

```bash
virtualenv env
source env/bin/activate
pip install -r requirements.txt
```

### Run migrate

```python
python manage.py makemigrations
python manage.py migrate
```

### Test on 8000 port with and without gunicorn

```bash
sudo ufw allow 8000 # allow 8000 in the firewall
python manage.py runserver 0.0.0.0:8000
```

Go to [http://server_domain_or_IP:8000](http://server_domain_or_IP:8000), it's very important to use http since you haven't set ssl certificate (no https support)

Now test the gunicorn. Gunicorn is an `application server` which serves your django app. 

```bash
gunicorn --bind 0.0.0.0:8000 my_blog.wsgi
```

### Set up Gunicorn service file

I use vim here, but you are free to use some more beginner-friendly editor like nano. The gunicorn service file is to ensure that gunicorn is run automatically in background to serve django

```bash
sudo vim /etc/systemd/system/gunicorn.service
```

An example service file using sammy as user looks as follows:

```bash
[Unit]
Description=gunicorn daemon
After=network.target

[Service]
User=sammy
Group=www-data
WorkingDirectory=/home/sammy/blog
ExecStart=/home/sammy/blog/env/bin/gunicorn --access-logfile - --workers 3 --bind unix:/home/sammy/my_blog.sock my_blog.wsgi:application

[Install]
WantedBy=multi-user.target
```

Now, start gunicorn!

```bash
sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket
```

### Set Nginx

```bash
sudo vim /etc/nginx/sites-available/blog
```

An example setting looks as following

```bash
server {
    server_name 142.93.110.76;

    location = /favicon.ico { access_log off; log_not_found off; }
    location /static/ {
        root /home/sammy/blog;
    }

    location /media/ {
        root /home/sammy/media;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/home/sammy/my_blog.sock;
    }
}
```

Make a symbolic link to make your setting available to nginx

```bash
sudo ln -s /etc/nginx/sites-available/blog /etc/nginx/sites-enabled
```

Test and start your Nginx server, you are good to go!

```bash
sudo nginx -t
sudo systemctl restart nginx
# stop 8000 port in the firewall
sudo ufw delete allow 8000
sudo ufw allow 'Nginx Full'
```

### Add a ssl certificate to make https available

Almost nobody uses http these days. Let's now see how to secure our site by adding a ssl certificate!

To have a more solid grasp on ssl certificate, see [reference here](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04).

```bash
sudo apt install certbot python3-certbot-nginx # install some useful packages
sudo vim /etc/nginx/sites-available/blog
```

Change the server_name line, example:
```bash
server_name 142.93.110.76 nlpinpython.com www.nlpinpython.com;
```

Restart Nginx and allow https in the firewall:
```bash
sudo systemctl reload nginx
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
```

Get a ssl certificat
```bash
sudo certbot --nginx -d nlpinpython.com -d www.nlpinpython.com
```

At the last step, select `redirect`
![](https://i.imgur.com/ia658lG.png)

Congratulations to make it this far.

## Most useful commands:

```bash
# set up nginx
sudo vim /etc/nginx/sites-available/blog
# set up gunicorn
sudo vim /etc/systemd/system/gunicorn.service
# restart gunicorn after change
sudo systemctl restart gunicorn
# restart nginx
sudo systemctl restart nginx
```

Export your database for backup:
```bash
sudo -i -u postgres -W
pg_dump dbname > dbexport.pgsql
```


> Supplementary references:

* about firewall https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04
* about postgresql backup https://www.digitalocean.com/community/tutorials/how-to-backup-postgresql-databases-on-an-ubuntu-vps
* general instructions https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu-20-04