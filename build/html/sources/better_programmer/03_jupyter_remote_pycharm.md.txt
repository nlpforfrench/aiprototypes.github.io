# Connect to remote jupyter notebook in Pycharm

By [Xiaoou Wang](https://https://scholar.google.fr/citations?user=vKAMMpwAAAAJ&hl=en)

I love working in Pycharm when it comes to jupyter notebooks because there is extensive support for common IDE features and a fantastic debugger.

However accessing remote jupyter notebook is a headache for newbies and the documentation is rather obscure, thus this tutorial.

First in your remote server, run

```bash
jupyter notebook --generate-config
```

Then use your favorite editor to edit the config file

```bash
vim ~/.jupyter/jupyter_notebook_config.py
```

Uncomment and set the following lines to

```bash
c.NotebookApp.ip = ‘*’
c.NotebookApp.port = ‘8888’
c.NotebookApp.open_brower = False
```

Set a password to avoid entering a token each time.

```bash
c.NotebookApp.token = "yourpassword"
```

Start jupyter notebook on the server

```bash
jupyter notebook
```

In Pycharm, click the triangle of the address bar to configure the server

![](img/03_jupyter_remote_pycharm/2021-04-14-15-13-56.png)

![](img/03_jupyter_remote_pycharm/2021-04-14-15-14-03.png)

Be sure to enter http, otherwise you’ll get an error message. See the issue reported [here](https://github.com/jupyter/notebook/issues/2265).

That’s it.

Enjoy!