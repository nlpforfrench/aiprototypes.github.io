# My codebase for bash/shell script (macOS)

## NLP

Excellent ressources:

http://www.stanford.edu/class/cs124/kwc-unix-for-poets.pdf
http://www.stanford.edu/class/cs124/lec/124-2021-UnixForPoets.pdf
https://web.stanford.edu/class/cs124/inclass_activity_solutions/activity1_solutions.txt

```bash
echo "this is a test S End." > testfile # write to file
cat testfile |tr a-z A-Z # convert to upper case
cat testfile | tr -d aeiouAEIOU # delete all vowels
cat testfile | tr -sc 'A-Za-z' '\n' | sort | uniq -c | head -n 5 # count and sort tokens, to downcase, | tr 'A-Z' 'a-z', tr '[:upper:]' '[:lower:]', c = complement s = squeeze ... to . (multiple to one)
```

## Cut

```
cut -c1-2 <<< 44150 # first 2 charac
tail -5 /etc/passwd | cut -d: -f1,6,7 # delimit, -f = field
```

## Previous code result

```bash
command && echo "OK" || echo "NOK"
```

## Read a file

```bash
cat < notes.csv
```

## Read from the keyboard, FIN to end

```bash
!sort -n << FIN # remove ! to run
```

## Error append to the file as well as other messages

```bash
cut -d , -f 1 fiche.csv >> eleves.txt 2>$1
cut -d , -f 1 fiche.csv 2> eleves.txt

# File descriptor 1 is the standard output (stdout).

# File descriptor 2 is the standard error (stderr).
```

## Print all the files folder

```bash
for f in \*.py; do echo "$f"; done
```

## Who is there?

```bash
who

w # who is doing what
```

## Watch process and kill

```bash
ps
ps -ef # all the process
ps -ejH # tree display
ps | grep
ps -u username # by user
kill id -9 # -9 = force

top # real time display

uptime # working since when?
```

## Run background

```bash
ctrl z # pause the current process

bg # continue in background
fg # put back to foreground
fg %2 # foreground the second

cp video.avi copie_video.avi &

nohup commande # nonstop after disconnection/or use tumux

jobs # see bg jobs
```

## Concatenate

```bash
cat \*.txt >> all.txt
```

## Watch gpu/hardware related

```bash
watch -d -n 0.5 nvidia-smi # https://unix.stackexchange.com/questions/38560/gpu-usage-monitoring-cuda

nvidia-smi -l 1 # will continually give you the gpu usage info, with in refresh interval of 1 second

lscpu # list cpu config
lspci -v | grep "VGA" -A 12 # check gpu
lsblk # check hard disk sized and mouting point

# general information
hostnamectl

# check cpu usage
htop

df -h ~ # check your own disk usage
cat /etc/os-release # check system

# check ip
curl ifconfig.me
```

## Replace string in files

```bash
find . -type f -print0 | xargs -0 perl -pi -e "s/\?digest.\*\"/\"/g" # use find, perl and regex, remove all ?digest like / / /

grep -rl static . | xargs gsed -i "s/\images/images/g" # use grep, gsed is necessary to avoir useless backupfiles on macOS, all files under static
```

## Tmux related

See [tmux codebase](./02_tmux.md)

## Stop process by keyboard

```bash
Ctrl-c # Ctrl-\ to hard kill
```
