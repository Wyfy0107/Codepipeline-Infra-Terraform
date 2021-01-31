#!/bin/bash

read -p "Enter load balancer url:" url

while true; do
  curl "${url}"
  echo
  sleep 1s
done