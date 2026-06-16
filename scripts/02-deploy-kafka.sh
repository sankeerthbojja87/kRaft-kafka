#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f manifests/strimzi/kafka-kraft-cluster.yaml
kubectl wait kafka/prod-kafka -n kafka --for=condition=Ready --timeout=900s
kubectl get pods -n kafka -o wide
kubectl get pvc -n kafka

