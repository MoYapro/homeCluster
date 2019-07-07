#!/bin/bash

kubectl delete all --all -n kube-system
kubectl delete all --all -n home-assistant
echo "wait 10s for pods to terminate"
sleep 10
kubectl apply -f flannel/kube-flannel.yaml

#kubectl apply -f traefik/traefik-rbac.yaml
#kubectl apply -f traefik/traefik-daemonset.yaml

