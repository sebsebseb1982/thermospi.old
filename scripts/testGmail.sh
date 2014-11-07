#!/bin/bash

#Script to check gmail
#Needed packages :: curl,sed,grep
#Created by Julian Gagnon

#Setting the variable
username=""                        #Input Gmail username here.

#OBD (On Bash Display)
clear
echo "###############"
echo "Gmail Bashified"
echo "###############"
echo " "
read -p "Password : " -esr password
echo " "
curl -su "$username":"$password" https://mail.google.com/mail/feed/atom -o /tmp/gmail.out # get the email and stick it in /tmp

#Parse xml file
grep -E "title|tagline|fullcount|summary|issued|name|email" /tmp/gmail.out \
|sed '/<summary><\/summary>/d'|sed '/<link/d'|sed '/<\/fullcount>/ a\ '\
|sed '/<\/email/ a\ '| sed -e :a -e 's/<[^<]*>/ /g;/</{N;s/\n/ /;ba;}'

# Delete temporary email
rm /tmp/gmail.out
