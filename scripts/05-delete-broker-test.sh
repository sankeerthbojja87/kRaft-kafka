#!/usr/bin/env bash
set -euo pipefail

echo "Deleting broker pod prod-kafka-broker-0 to simulate broker failure..."
kubectl delete pod prod-kafka-broker-0 -n kafka
echo "Watch recovery with:"
echo "  kubectl get pods -n kafka -w"
echo "  kubectl describe kafka prod-kafka -n kafka"

