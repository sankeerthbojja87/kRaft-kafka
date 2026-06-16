#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f manifests/topics/orders-topic.yaml
kubectl apply -f manifests/users/orders-app-user.yaml
kubectl get kafkatopic,kafkauser -n kafka

