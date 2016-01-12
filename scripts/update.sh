#!/bin/bash
source ~/thermospi/scripts/setVars.sh

updateRealPlots() {
   echo "Mise à jour de la courbe de consigne de température réelle"
   # On lit la derniere consigne de temperature
   DERNIERE_CONSIGNE_TEMPERATURE_REELLE=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT s.value FROM realsetpoints s WHERE s.date < NOW() ORDER BY s.date DESC LIMIT 1' $DB_NAME)

   # Si elle est differente de la courente
   if [ `bc <<< $2' != '$DERNIERE_CONSIGNE_TEMPERATURE_REELLE` = 1 ]
   then
      # On l'enregistre
      mysql -u $DB_USER -p$DB_PASSWORD -e 'INSERT INTO realsetpoints (date,value) VALUES (NOW(), '$2')' $DB_NAME
   fi

   echo "Mise à jour de la courbe de chauffe réelle"
   # On lit la derniere consigne de chauffe
   DERNIERE_CONSIGNE_CHAUFFE_REELLE=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT s.status FROM temperatures.`realstatus` s WHERE s.date < NOW() ORDER BY s.date DESC LIMIT 1' $DB_NAME)

   # Si elle est differente de la courente
   if [ $1 != $DERNIERE_CONSIGNE_CHAUFFE_REELLE ]
   then
      # On l'enregistre
      mysql -u $DB_USER -p$DB_PASSWORD -e 'INSERT INTO realstatus (date,status) VALUES (NOW(), '$1')' $DB_NAME
   fi
}

updateGPIO() {
   gpio mode $GPIO_THERMOSTAT out
   gpio write $GPIO_THERMOSTAT $1
   NOUVEL_ETAT=$(traduireEtatVersAffichage $1)
   echo "Nouvelle consigne thermostat -> "$NOUVEL_ETAT

   updateRealPlots $1 $2
}

updateThermostat() {
   # On met a jour la sortie GPIO en fonction de l'etat voulu
   updateGPIO $1 $2

   # On met a jour l'etat du thermostat si necessaire
   if [ $ETAT_COURANT_THERMOSTAT != $1 ]
   then
      mysql -u $DB_USER -p$DB_PASSWORD -e 'INSERT INTO status (date,status,priority) VALUES (NOW(), '$1', '$THERMOSTAT_LEVEL')' $DB_NAME
   fi
}

traduireEtatVersAffichage() {
   if [ $1 == "NULL"  ]
   then
      echo "Automatique"
   elif [ $1 == 0 ]
   then
      echo "Arret"
   elif [ $1 == 1 ]
   then
      echo "Marche"
   else
      echo "Erreur ! ("$1")"
   fi
}

afficherConsignePourNiveau() {
   echo "Consigne "$1" (priorite="$2") -> "$3
}

# On recupere la consigne de chauffage courante
CONSIGNE_TEMPERATURE=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT s.value FROM setpoints s WHERE s.date < NOW() ORDER BY s.date DESC LIMIT 1' $DB_NAME)

# On recupere la temperature moyenne recente du RDC et de l'etage
TEMPERATURE_AMBIANTE=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT ROUND(AVG(value),3) FROM records WHERE date > (NOW() - INTERVAL '$TEMPERATURE_RECORD_FREQUENCY' minute) AND (sensorId = 2 OR sensorId = 3)' $DB_NAME)

echo "Temperature [actuellement="$TEMPERATURE_AMBIANTE"°C, cible="$CONSIGNE_TEMPERATURE"°C]"

# On recupere la derniere consigne de niveau utilisateur
DERNIERE_CONSIGNE_NIVEAU_UTILISATEUR=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT s.status FROM temperatures.`status` s WHERE s.date < NOW() AND s.priority = '$USER_LEVEL' ORDER BY s.date DESC LIMIT 1' $DB_NAME)
afficherConsignePourNiveau "utilisateur" $USER_LEVEL $(traduireEtatVersAffichage $DERNIERE_CONSIGNE_NIVEAU_UTILISATEUR)

# Si chauffage mode AUTO
if [ "$DERNIERE_CONSIGNE_NIVEAU_UTILISATEUR" == "NULL" ]
then

   # On recupere la derniere consigne de niveau systeme
   DERNIERE_CONSIGNE_NIVEAU_SYSTEME=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT s.status FROM temperatures.`status` s WHERE s.date < NOW() AND s.priority = '$SYSTEM_LEVEL' ORDER BY s.date DESC LIMIT 1' $DB_NAME)
   afficherConsignePourNiveau "systeme" $SYSTEM_LEVEL $(traduireEtatVersAffichage $DERNIERE_CONSIGNE_NIVEAU_SYSTEME)

   # Si qq'un est present dans la maison
   if [ "$DERNIERE_CONSIGNE_NIVEAU_SYSTEME" == 1 ]
   then

      # On recupere la derniere consigne de niveau thermostat
      ETAT_COURANT_THERMOSTAT=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT s.status FROM temperatures.`status` s WHERE s.date < NOW() AND s.priority = '$THERMOSTAT_LEVEL' ORDER BY s.date DESC LIMIT 1' $DB_NAME)
      afficherConsignePourNiveau "thermostat" $THERMOSTAT_LEVEL $(traduireEtatVersAffichage $ETAT_COURANT_THERMOSTAT)

      # Si la temperature moyenne est inferieure a la consigne moins l'hysteresis
      if [ `bc <<< $TEMPERATURE_AMBIANTE' < '$CONSIGNE_TEMPERATURE' - '$HYSTERESIS` = 1 ]
      then
         updateThermostat 1 $CONSIGNE_TEMPERATURE

      # Si le thermostat est actuellement ON et que la temperature moyenne est superieure a la consigne plus l'hysteresis
      elif [ `bc <<< $TEMPERATURE_AMBIANTE' > '$CONSIGNE_TEMPERATURE` = 1 ]
      then
         updateThermostat 0 $CONSIGNE_TEMPERATURE
      fi

   # Si maison vide
   else
      updateGPIO 0 0
   fi

# Si chauffage arrete
elif [ "$DERNIERE_CONSIGNE_NIVEAU_UTILISATEUR" == 0 ]
then
   updateGPIO 0 0

# Si chauffage demarre
elif [ "$DERNIERE_CONSIGNE_NIVEAU_UTILISATEUR" == 1 ]
then
   updateGPIO 1 40
fi
