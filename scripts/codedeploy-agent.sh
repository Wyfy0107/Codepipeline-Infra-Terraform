#!/bin/bash

sudo apt-get update
sudo apt-get install -y ruby
sudo apt -y install stress-ng
cd /home/ubuntu
curl -O https://aws-codedeploy-eu-west-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto > /tmp/logfile