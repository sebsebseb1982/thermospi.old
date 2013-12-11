#!/bin/bash

setVar() {
   echo "Set "$1" -> "$2
   eval "$1=$2"
}

# Infos BDD
setVar DB_USER seb
setVar DB_PASSWORD seb
setVar DB_NAME temperatures

# Priorites
setVar USER_LEVEL 3
setVar SYSTEM_LEVEL 2
setVar THERMOSTAT_LEVEL 1

# N° GPIO relai chauffage
setVar GPIO_THERMOSTAT 0

# Frequence d'enregistrement des temperatures
setVar TEMPERATURE_RECORD_FREQUENCY 15

setVar HYSTERESIS 0.5
