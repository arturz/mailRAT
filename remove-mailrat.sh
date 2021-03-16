#!/bin/bash

rm /etc/fetchmailrc &> /dev/null
rm /etc/fetchmailparser &> /dev/null
rm /tmp/mailscript.sh &> /dev/null

crontab -u $SUDO_USER -l | grep -v /etc/fetchmailrc | > /tmp/cronjobs.txt
crontab -u $SUDO_USER /tmp/cronjobs.txt
rm /tmp/cronjobs.txt

