#!/bin/bash

kubectl apply -f system
kubectl apply -f flannel
kubectl apply -f pihole
kubectl apply -f traefik
kubectl apply -f duckdns
kubectl apply -f mosquitto
kubectl apply -f home-assistant
kubectl apply -f node-red

