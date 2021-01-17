#!/bin/bash

kubectl delete configmap floorplan-config
kubectl create configmap floorplan-config --from-file=.
