#!/bin/bash

kubectl delete all --all -n kube-system
kubectl delete all --all -n home-assistant
echo "wait 3s for pods to terminate"
sleep 3
kubectl apply -f flannel/kube-flannel.yaml

kubectl apply -f whoami-test/deployment.yaml
kubectl apply -f whoami-test/ingress.yaml

kubectl apply -f traefik/traefik-rbac.yaml
kubectl apply -f traefik/traefik-daemonset.yaml

