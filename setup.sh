#!/usr/bin/env bash

set -e

LE_USER=letsencrypt
LE_HOME=/home/$LE_USER
LE_CRON=le-cron.sh

for CMD in sudo git
do
	if ! type $CMD >/dev/null 2>&1; then
		echo "$CMD require but it's not installed. Install with: apt-get install $CMD" >&2
		exit 1
	fi
done

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if ! grep "^${LE_USER}:" /etc/passwd > /dev/null; then
	adduser --home $LE_HOME letsencrypt
	usermod -a -G www-data $LE_USER
	chgrp www-data $LE_HOME
	chmod g+r $LE_HOME
else
   echo "User letsencrypt alredy exist." 1>&2
   exit 1
fi

cd $LE_HOME

git clone https://github.com/lukas2511/letsencrypt.sh.git bin
cd bin
git checkout v0.1.0
cd ..

echo "WELLKNOWN=\"$LE_HOME/www\"
CONTACT_EMAIL=\"admin@example.com\"
" > config.sh

echo "example.com www.example.com
example.org www.example.org webmail.example.org
" > domains.txt

mkdir www

if ! grep $LE_CRON /etc/crontab > /dev/null; then
	# Refresh certificates once per two weeks at evening
	echo "`shuf -i 10-45 -n 1` `shuf -i 19-21 -n 1` 1-7,15-21 * * root [ \`LC_ALL=C date +\\%a\` = `printf 'Sun\nMon\nTue\nWed\nThu\nFri\nSat\n' | shuf -n1` ] && $LE_HOME/$LE_CRON" >> /etc/crontab
else
   echo "Cron task for $LE_CRON alredy exist." 1>&2
   exit 1
fi
