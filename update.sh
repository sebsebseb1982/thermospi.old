#!/bin/bash

# On recupere la consigne de chauffage
CONSIGNE_TEMPERATURE=$(mysql -u seb -pseb -se 'SELECT value FROM constants where name="consigne"' temperatures)
echo "Consigne de temperature:"$CONSIGNE_TEMPERATURE

# On recupere l'intervalle d'enregistrement de temperature
INTERVALLE=$(mysql -u seb -pseb -se 'SELECT value FROM constants where name="intervalle"' temperatures)
echo "Intervalle d'enregistremment de la temperature:"$INTERVALLE

# On recupere l'etat courant du thermostat
THERMOSTAT_STATE=$(mysql -u seb -pseb -se 'SELECT state FROM states ORDER BY date DESC LIMIT 1' temperatures)
echo "Statut actuel du thermostat:"$THERMOSTAT_STATE

# On recupere la temperature moyenne recente du RDC et de l'etage
TEMPERATURE_AMBIANTE=$(mysql -u seb -pseb -se 'SELECT AVG(value) FROM records WHERE date > (NOW() - INTERVAL '$INTERVALLE' minute) AND (sensorId = 2 OR sensorId = 3)' temperatures)
echo "Temperature moyenne des "$INTERVALLE" dernieres minutes:"$TEMPERATURE_AMBIANTE

# On recupere l'hysteresis du thermostat
HYSTERESIS=$(mysql -u seb -pseb -se 'SELECT value FROM constants where name="hysteresis"' temperatures)
echo "Hysteresis du thermostat:"$HYSTERESIS

# Si le thermostat est actuellement coupe et que la temperature moyenne est inferieure a la consigne moins l'hysteresis
if [ $THERMOSTAT_STATE = 0 ] && [ `bc <<< $TEMPERATURE_AMBIANTE' < '$CONSIGNE_TEMPERATURE' - '$HYSTERESIS` = 1 ]
then
   echo "Allumage du chauffage";

   # On met la sortie relais a 1
   gpio mode 0 out
   gpio write 0 1

   # On sauvegarde la consigne 1 en base
   mysql -u seb -pseb -e 'INSERT INTO states (date,state) VALUES (NOW(), TRUE)' temperatures

fi

# Si le thermostat est actuellement allume et que la temperature moyenne est superieure a la consigne plus l'hysteresis
if [ $THERMOSTAT_STATE = 1 ] && [ `bc <<< $TEMPERATURE_AMBIANTE' > '$CONSIGNE_TEMPERATURE' + '$HYSTERESIS` = 1 ]
then
   echo "Extinction du chauffage";

   # On met la sortie relais a 0
   gpio mode 0 out
   gpio write 0 0

   # On sauvegarde la consigne 1 en base
   mysql -u seb -pseb -e 'INSERT INTO states (date,state) VALUES (NOW(), FALSE)' temperatures

fi
