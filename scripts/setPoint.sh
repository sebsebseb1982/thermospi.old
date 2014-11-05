#!/bin/bash
source ~/thermospi/scripts/setVars.sh

# Insertion de la consigne en base 
mysql -u $DB_USER -p$DB_PASSWORD -e 'INSERT INTO setpoints (date,value) VALUES (NOW(), '$1')' temperatures
echo "Consigne de chauffage : "$1"°C"

sleep 1

~/thermospi/update.sh
