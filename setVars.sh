#!/bin/bash

setVar() {
   echo "Set "$1" -> "$2
   eval "$1=$2"
}

echo "[START] Set vars"

setVar DB_USER seb
setVar DB_PASSWORD seb
setVar USER_LEVEL 3
setVar SYSTEM_LEVEL 2
setVar THERMOSTAT_LEVEL 1
setVar GPIO_THERMOSTAT 0

echo "[STOP] Set vars"
