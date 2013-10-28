#!/bin/bash

# On charge les drivers pour les capteurs de temperature
sudo modprobe w1-gpio
sudo modprobe w1-therm

# On met les sorties de relais a 0
gpio mode 0 out
gpio mode 1 out
gpio mode 2 out
gpio mode 3 out
gpio write 0 0
gpio write 1 0
gpio write 2 0
gpio write 3 0

# On sauvegarde la consigne 0 en base
mysql -u seb -pseb -e 'INSERT INTO states (date,state) VALUES (NOW(), FALSE)' temperatures
