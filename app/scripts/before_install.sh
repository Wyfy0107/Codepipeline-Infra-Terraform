#!/bin/bash

curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
sudo apt update
sudo apt -y install nodejs
sudo npm i -g pm2 