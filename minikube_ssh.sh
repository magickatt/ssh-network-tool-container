#!/bin/bash

MINIKUBE_IP=$(minikube ip)
MINIKUBE_NODEPORT=$(kubectl get svc ssh-network-tools -o=jsonpath="{.spec.ports[?(@.port==22)].nodePort}

echo "ssh $MINIKUBE_IP -p $MINIKUBE_NODEPORT -l user"
