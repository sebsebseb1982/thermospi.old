#!/bin/bash

username=$1
password=$2

curl -u $username:$password --silent "https://mail.google.com/mail/feed/atom" |  grep -oPm1 "(?<=<title>)[^<]+" | sed '1d' | while read arg1; do
   REGEX="([a-zA-Z]+)rmement.*"

   if [[ $arg1 =~ $REGEX ]]
   then
      if [ "${BASH_REMATCH[1]}" = "A" ]
      then
         echo "Maison fermee"
         exit 0
      else
         echo "Maison ouverte"
         exit 1
      fi
   fi
done
