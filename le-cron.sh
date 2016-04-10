#!/bin/bash

set -e
set -u
set -o pipefail

LE_DIR=/home/letsencrypt

LASTRUN=$LE_DIR/lastrun

chown -R letsencrypt.users $LE_DIR/bin/

sudo -u letsencrypt $LE_DIR/bin/letsencrypt.sh --cron --config $LE_DIR/config.sh

chown -R nginx.www-data $LE_DIR/certs

chmod -R g+rwX $LE_DIR/certs

NEWCERTS=`find $LE_DIR/certs -type f -newer $LASTRUN | wc -l`

[ $NEWCERTS -gt 0 ] && /etc/init.d/nginx configtest && /etc/init.d/nginx reload && touch $LASTRUN
