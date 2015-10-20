#!/bin/bash
source ~/thermospi/scripts/setVars.sh

# Pour tous les capteurs de temperature
mysql -u $DB_USER -p$DB_PASSWORD -e "SELECT * FROM sensors" $DB_NAME | tail -n 3 | while read id label path; do

   # Lecture complete de la sortie du capteur
   FULL_TEMP_STRING=`cat $path`

   # On initialise la termperature
   TEMP_VALUE=100

   # Tant que la temperature n'est pas a une valeur correcte CAD < 55 degres
   while [[ `bc <<< $TEMP_VALUE' > 55'` == 1 ]]; do
      # Tant que le CRC de la lecture du capteur n'est pas OK
      while [[ $FULL_TEMP_STRING == *NO* ]]; do

         # Lecture complete de la sortie du capteur
         FULL_TEMP_STRING=`cat $path`
      done

      # Lecture de la valeur sur le capteur en string (Ex:32125 --> 32,125 degres)
      TEMP_STRING=`echo $FULL_TEMP_STRING | tail -n 1 | grep -o "t=.*" | cut -c3-`

      # Transformation en float
      TEMP_VALUE=`bc <<< 'scale=3; '$TEMP_STRING' / 1000'`

   done

   echo "Capteur["$id"|"$label"|"$path"] : "$TEMP_VALUE"°C"

   # Insertion de la valeur en base
   mysql -u $DB_USER -p$DB_PASSWORD -e 'INSERT INTO records (date,value,sensorId) VALUES (NOW(),'$TEMP_VALUE','$id')' $DB_NAME
done
