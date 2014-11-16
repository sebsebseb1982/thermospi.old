#!/bin/bash
source ~/thermospi/scripts/setVars.sh

# On verifie si il y a qq'un dans la maison
LAST_MAILS=`curl -u $1:$2 --silent "https://mail.google.com/mail/feed/atom/alarme/all"`

REGEX="([a-z]+)rmement.*"

if [[ $LAST_MAILS =~ $REGEX ]]
then
   name="${BASH_REMATCH[1]}"
   echo $name
fi
echo $LAST_MAILS
