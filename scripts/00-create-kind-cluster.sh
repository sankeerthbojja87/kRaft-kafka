#!/usr/bin/env bash
set -euo pipefail

kind create cluster --config kind/kind-config.yaml
kubectl cluster-info --context kind-kafka-prod-lab

