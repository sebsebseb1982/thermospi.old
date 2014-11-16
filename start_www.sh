#!/bin/bash
nohup node ~/thermospi/api/server.js &
cd ~/thermospi/www/ && nohup npm start

