#!/bin/bash

IMAP_SERVER=imap.wmi.amu.edu.pl
IMAP_PORT=993
SMTP_SERVER=smtp.wmi.amu.edu.pl
# SMTP_PORT=465
SERVER=wmi.amu.edu.pl
USER=s464887

rm /etc/fetchmailrc &> /dev/null
rm /etc/fetchmailparser.sh &> /dev/null


CONSOLE_USER=$SUDO_USER
if [[ -z $CONSOLE_USER ]]
then
	CONSOLE_USER=$(id -u -n)
fi

echo "Configuring for ${CONSOLE_USER}"
echo "Mail server password:"
read -s PASSWORD


if [[ -z $(command -v fetchmail) ]] ; then
	apt-get update
	apt-get -y install fetchmail
fi

if [[ -z $(command -v sendemail) ]] ; then
	apt-get update
	apt-get -y install sendemail
fi

if [[ $(dpkg --status libnet-ssleay-perl &> /dev/null) -ne 0 ]] || [[ $(dpkg --status libio-socket-ssl-perl &> /dev/null) -ne 0 ]] ; then
	apt-get update
	apt-get -y install libnet-ssleay-perl libio-socket-ssl-perl
fi


cat > /etc/fetchmailrc << EOF
	poll $IMAP_SERVER
	protocol IMAP
	user "${USER}@${SERVER}" with password "${PASSWORD}" mda "/etc/fetchmailparser.sh"
	folder 'INBOX'
	#fetchlimit 1
	#keep
	ssl
EOF

chown $CONSOLE_USER /etc/fetchmailrc
chmod 710 /etc/fetchmailrc



cat > /etc/fetchmailparser.sh << EOF
#!/bin/bash
	FROM=
	SUBJECT=
	CODE_STARTED=false
	HAS_CODE=false
	while read line
	do
		if [[ \$line = From:* ]] && [[ -z \$FROM ]]
		then
			FROM=\$(echo \$line | tr -d "<>" | awk '{print \$NF}')
		elif [[ \$line = Subject:* ]] && [[ -z \$SUBJECT ]]
		then
			SUBJECT=\$(echo \$line | tr -d "<>" | awk '{print \$NF}')
		elif [[ \$line = CODE* ]] && [[ \$SUBJECT = RUN* ]]
		then
			echo "" > /tmp/mailscript.sh
			CODE_STARTED=true
			HAS_CODE=true
		elif [[ \$line = ENDCODE* ]]
		then
			CODE_STARTED=false
		elif [[ \$CODE_STARTED = true ]]
		then
			echo \$line >> /tmp/mailscript.sh
		fi
	done
	
	if [[ \$HAS_CODE = true ]]
	then
		OUTPUT=\$(bash /tmp/mailscript.sh)
		sendemail -f "${USER}@${SERVER}" -t \${FROM} -u "RUN code result" -m "<pre>\${OUTPUT}</pre>" -s ${SMTP_SERVER} -xu ${USER} -xp ${PASSWORD} -o tls=yes -o message-content-type=html -q
	fi
EOF

chown $CONSOLE_USER /etc/fetchmailparser.sh
chmod 710 /etc/fetchmailparser.sh



# configure crontab

crontab -u $CONSOLE_USER -l | grep -v /etc/fetchmailrc | > /tmp/cronjobs.txt
echo "* * * * * fetchmail -f /etc/fetchmailrc &> /dev/null" >> /tmp/cronjobs.txt
crontab -u $CONSOLE_USER /tmp/cronjobs.txt
rm /tmp/cronjobs.txt

echo "crontab updated"
echo "done"
