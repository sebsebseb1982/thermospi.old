#!/bin/bash
source ~/thermospi/setVars.sh

updateThermostat() {
   gpio mode $GPIO_THERMOSTAT out
   gpio write $GPIO_THERMOSTAT $1
   echo "Nouvel état thermostat -> "$1
}

# On recupere la consigne de chauffage courante
CONSIGNE_TEMPERATURE=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT s.value FROM setpoints s WHERE s.date < NOW() ORDER BY s.date DESC LIMIT 1' $DB_NAME)
echo "Consigne de temperature -> "$CONSIGNE_TEMPERATURE"°C"

# On recupere la derniere consigne de niveau utilisateur
DERNIERE_CONSIGNE_NIVEAU_UTILISATEUR=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT s.status FROM temperatures.`status` s WHERE s.date < NOW() AND s.priority = '$USER_LEVEL' ORDER BY s.date DESC LIMIT 1' $DB_NAME)
echo "Derniere consigne niveau utilisateur (priorite="$USER_LEVEL") -> "$DERNIERE_CONSIGNE_NIVEAU_UTILISATEUR

# Si chauffage mode AUTO
if [ "$DERNIERE_CONSIGNE_NIVEAU_UTILISATEUR" == "NULL" ]
then

   # On recupere la derniere consigne de niveau systeme
   DERNIERE_CONSIGNE_NIVEAU_SYSTEME=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT s.status FROM temperatures.`status` s WHERE s.date < NOW() AND s.priority = '$SYSTEM_LEVEL' ORDER BY s.date DESC LIMIT 1' $DB_NAME)
   echo "Derniere consigne niveau systeme     (priorite="$SYSTEM_LEVEL") -> "$DERNIERE_CONSIGNE_NIVEAU_SYSTEME

   # Si qq'un est present dans la maison
   if [ "$DERNIERE_CONSIGNE_NIVEAU_SYSTEME" == 1 ]
   then

      # On recupere la derniere consigne de niveau thermostat
      ETAT_COURANT_THERMOSTAT=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT s.status FROM temperatures.`status` s WHERE s.date < NOW() AND s.priority = '$THERMOSTAT_LEVEL' ORDER BY s.date DESC LIMIT 1' $DB_NAME)
      echo "Etat courant thermostat              (priorite="$THERMOSTAT_LEVEL") -> "$ETAT_COURANT_THERMOSTAT

      # On recupere la temperature moyenne recente du RDC et de l'etage
      TEMPERATURE_AMBIANTE=$(mysql -u $DB_USER -p$DB_PASSWORD -se 'SELECT AVG(value) FROM records WHERE date > (NOW() - INTERVAL '$TEMPERATURE_RECORD_FREQUENCY' minute) AND (sensorId = 2 OR sensorId = 3)' $DB_NAME)
      echo "Temperature moyenne des "$TEMPERATURE_RECORD_FREQUENCY" dernieres minutes -> "$TEMPERATURE_AMBIANTE"°C"

      # Si le thermostat est actuellement coupe et que la temperature moyenne est inferieure a la consigne moins l'hysteresis
      if [ $ETAT_COURANT_THERMOSTAT = 0 ] && [ `bc <<< $TEMPERATURE_AMBIANTE' < '$CONSIGNE_TEMPERATURE' - '$HYSTERESIS` = 1 ]
      then
         updateThermostat 1
         mysql -u $DB_USER -p$DB_PASSWORD -e 'INSERT INTO status (date,status,priority) VALUES (NOW(), 1, '$THERMOSTAT_LEVEL')' $DB_NAME

      # Si le thermostat est actuellement allume et que la temperature moyenne est superieure a la consigne plus l'hysteresis
      elif [ $ETAT_COURANT_THERMOSTAT = 1 ] && [ `bc <<< $TEMPERATURE_AMBIANTE' > '$CONSIGNE_TEMPERATURE' + '$HYSTERESIS` = 1 ]
      then
         updateThermostat 0
         mysql -u $DB_USER -p$DB_PASSWORD -e 'INSERT INTO status (date,status,priority) VALUES (NOW(), 0, '$THERMOSTAT_LEVEL')' $DB_NAME
      fi

   # Si maison vide
   else
      updateThermostat 0
   fi

# Si chauffage eteint
elif [ "$DERNIERE_CONSIGNE_NIVEAU_UTILISATEUR" == 0 ]
then
   updateThermostat 0

# Si chauffage allume
elif [ "$DERNIERE_CONSIGNE_NIVEAU_UTILISATEUR" == 1 ]
then
   updateThermostat 1
fi
