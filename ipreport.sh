#!/bin/bash

if [ -z "$1" ]; then
  echo "You must supply an email address"
  exit 1
fi

FILE="currentip"
HOSTNAME=`hostname`
EMAIL=$1
IP=`wget -q -O - checkip.net-me.net/plain`

if [[ ! -e $FILE ]]; then
  echo $IP > $FILE
elif [ '$(head -n 1 $FILE)' != $IP ]; then
  echo $IP > $FILE
  mail -s "$HOSTNAME has a new IP!" vchwalowski@gmail.com <<< $FILE
fi
