#!/bin/bash
cd ~/thermospi/ && git pull
nohup node ~/thermospi/api/server.js &
cd ~/thermospi/www/ && nohup npm start

