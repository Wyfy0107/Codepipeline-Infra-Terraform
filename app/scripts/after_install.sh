#!/bin/bash

cd /home/ubuntu/app
sudo npm install
pm2 delete index >& /dev/null || true