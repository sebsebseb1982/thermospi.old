#!/bin/bash

# Pour tous les capteurs de temperature
mysql -u seb -pseb -e "SELECT * FROM sensors" temperatures | tail -n 3 | while read id label path; do
   echo "Capteur: "$id" / "$label" / "$path

   # Lecture complete de la sortie du capteur
   FULL_TEMP_STRING=`cat $path`

   # Tant que le CRC de la lecture du capteur n'est pas OK
   while [[ $FULL_TEMP_STRING == *NO* ]]; do

      # Lecture complete de la sortie du capteur
      FULL_TEMP_STRING=`cat $path`
   done

   # Lecture de la valeur sur le capteur en string (Ex:32125 --> 32,125 degres)
   TEMP_STRING=`echo $FULL_TEMP_STRING | tail -n 1 | grep -o "t=.*" | cut -c3-`

   # Transformation en float
   TEMP_VALUE=`bc <<< 'scale=3; '$TEMP_STRING' / 1000'`

   # Insertion de la valeur en base
   mysql -u seb -pseb -e 'INSERT INTO records (date,value,sensorId) VALUES (NOW(),'$TEMP_VALUE','$id')' temperatures

done
