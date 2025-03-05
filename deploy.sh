#!bin/sh
kubectl apply -f ns.yaml
kubectl apply -f secret.yaml
kubectl apply -f deploy.yaml
kubectl apply -f svc.yaml
