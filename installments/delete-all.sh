#!/bin/bash

kubectl delete all --all -n kube-system
kubectl delete all --all -n home-assistant
echo "wait 3s for pods to terminate"
sleep 3
