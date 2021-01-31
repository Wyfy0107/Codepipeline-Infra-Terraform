#!/bin/bash

read -p "Enter public ip of the instance" ip
ssh -i "./instance.key" ubuntu@"${ip}"