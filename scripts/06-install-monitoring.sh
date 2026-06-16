#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f manifests/monitoring/prometheus.yaml
kubectl apply -f manifests/monitoring/grafana.yaml
kubectl get pods -n monitoring

cat <<'INSTRUCTIONS'
Port-forward Prometheus:
  kubectl port-forward svc/prometheus -n monitoring 9090:9090

Port-forward Grafana:
  kubectl port-forward svc/grafana -n monitoring 3000:3000

Grafana login:
  admin / admin
INSTRUCTIONS

