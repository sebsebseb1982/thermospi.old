#!/bin/bash
source ~/thermospi/scripts/setVars.sh

setVar TEMPERATURE_MAXIMUM_SUPPORTABLE 22
# On verifie si il y a qq'un dans la maison
~/thermospi/scripts/toctoc.sh $1 $2
PRESENCE=$?

# Si la detection de presence s'est correctement passee
if [[ $PRESENCE == 0 || $PRESENCE == 1 ]]
then
   echo "Presence dans la maison (code retour: "$PRESENCE")"

   # Lecture de la température moyenne dans la maison
   TEMPERATURE_INTERIEURE=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT ROUND(AVG(value),3) FROM records WHERE date > (NOW() - INTERVAL '$TEMPERATURE_RECORD_FREQUENCY' minute) AND (sensorId = 2 OR sensorId = 3)' $DB_NAME)

   echo "Température intérieure : "$TEMPERATURE_INTERIEURE"°C"

   # Si il fait plus de x°C dans la maison
   if [ `bc <<< $TEMPERATURE_INTERIEURE' > '$TEMPERATURE_MAXIMUM_SUPPORTABLE` = 1 ]
   then

      # Lecture de la température extérieure
      TEMPERATURE_EXTERIEURE=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT value FROM records WHERE date > (NOW() - INTERVAL '$TEMPERATURE_RECORD_FREQUENCY' minute) AND sensorId = 1' $DB_NAME)
    
      echo "Température extérieure : "$TEMPERATURE_EXTERIEURE"°C"
      MESSAGE="Interieur : $TEMPERATURE_INTERIEURE°C - Exterieur : $TEMPERATURE_EXTERIEURE°C"

      # Si il fait moins chaud dehors qu'à l'intérieur
      if [ `bc <<< $TEMPERATURE_INTERIEURE' > '$TEMPERATURE_EXTERIEURE` = 1 ]
      then

         echo "Il faut aérer la maison"
         rm -f .fenetres_fermees

         if [ ! -f .fenetres_ouvertes ]
         then
            touch .fenetres_ouvertes
            ~/thermospi/scripts/nma.sh "Temperature" "Ouvrir les fenetres" "$MESSAGE" 1
         fi

      else 

         echo "Il fait trop chaud pour aérer la maison"
         rm -f .fenetres_ouvertes

         if [ ! -f .fenetres_fermees ]
         then
            touch .fenetres_fermees
            ~/thermospi/scripts/nma.sh "Temperature" "Fermer les fenetres" "$MESSAGE" 1
         fi

      fi
   else 

      echo "Il est inutile d'aérer la maison"

   fi
# Sinon,
else
   echo "Personne dans la maison (code retour : "$PRESENCE")"
fi
