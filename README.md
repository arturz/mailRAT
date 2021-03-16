# MailRAT

The script reads from a given mailbox every minute and then executes the message's content as a Bash shell command.

## Configuration

Change IMAP and SMTP configuration inside bash file.

Run:
```sudo bash mailrat.sh```

It will install necessary packages and configure cronjob for currently logged in user.

## Clearing up:
```./remove-mailrat.sh```


## Mail structure

**Subject:** RUN

**Content:**
```
CODE
echo Hello
ls -la /
ENDCODE
```

## Response mail

**Subject:** RUN code result

**Content:**
```
Hello
total 620
drwxr-xr-x  1 root root   4096 Mar 11 08:39 .
drwxr-xr-x  1 root root   4096 Mar 11 08:39 ..
lrwxrwxrwx  1 root root      7 Apr 23  2020 bin -> usr/bin
drwxr-xr-x  1 root root   4096 Apr 23  2020 boot
drwxr-xr-x  1 root root   4096 Mar 16 12:20 dev
drwxr-xr-x  1 root root   4096 Mar 16 12:20 etc
drwxr-xr-x  1 root root   4096 Mar 11 08:39 home
-rwxr-xr-x  1 root root 632048 Mar 12 00:37 init
lrwxrwxrwx  1 root root      7 Apr 23  2020 lib -> usr/lib
lrwxrwxrwx  1 root root      9 Apr 23  2020 lib32 -> usr/lib32
lrwxrwxrwx  1 root root      9 Apr 23  2020 lib64 -> usr/lib64
lrwxrwxrwx  1 root root     10 Apr 23  2020 libx32 -> usr/libx32
drwxr-xr-x  1 root root   4096 Apr 23  2020 media
drwxr-xr-x  1 root root   4096 Mar 11 08:39 mnt
drwxr-xr-x  1 root root   4096 Apr 23  2020 opt
dr-xr-xr-x  9 root root      0 Mar 16 12:20 proc
drwx------  1 root root   4096 Mar 12 16:21 root
drwxr-xr-x  1 root root   4096 Mar 16 12:20 run
lrwxrwxrwx  1 root root      8 Apr 23  2020 sbin -> usr/sbin
drwxr-xr-x  1 root root   4096 Apr 10  2020 snap
drwxr-xr-x  1 root root   4096 Apr 23  2020 srv
dr-xr-xr-x 12 root root      0 Mar 16 12:20 sys
drwxrwxrwt  1 root root   4096 Mar 15 14:38 tmp
drwxr-xr-x  1 root root   4096 Apr 23  2020 usr
drwxr-xr-x  1 root root   4096 Apr 23  2020 var
```