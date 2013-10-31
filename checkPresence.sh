#!/bin/bash
source ~/thermospi/setVars.sh

# On verifie si il y a qq'un dans la maison
~/toctoc/start.sh $1 $2
PRESENCE=$?
echo "Presence dans la maison -> "$PRESENCE

# On recupere la derniere consigne de niveau systeme
DERNIERE_CONSIGNE_NIVEAU_SYSTEME=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT s.status FROM temperatures.`status` s WHERE s.date < NOW() AND s.priority = '$SYSTEM_LEVEL' ORDER BY s.date DESC LIMIT 1' $DB_NAME)
echo "Derniere consigne niveau systeme     (priorite="$SYSTEM_LEVEL") -> "$DERNIERE_CONSIGNE_NIVEAU_SYSTEME

# Si la valeur a changee depuis le dernier poll
if [ $PRESENCE != $DERNIERE_CONSIGNE_NIVEAU_SYSTEME ]
then
   mysql -u $DB_USER -p$DB_PASSWORD -e 'INSERT INTO status (date,status,priority) VALUES (NOW(),'$PRESENCE','$SYSTEM_LEVEL')' $DB_NAME
fi
