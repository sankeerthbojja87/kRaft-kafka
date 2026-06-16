#!/usr/bin/env bash
set -euo pipefail

cat <<'INSTRUCTIONS'
This opens a temporary Kafka client pod.

Inside the pod, run:

  bin/kafka-topics.sh \
    --bootstrap-server prod-kafka-kafka-bootstrap:9092 \
    --list

Producer:

  bin/kafka-console-producer.sh \
    --bootstrap-server prod-kafka-kafka-bootstrap:9092 \
    --topic orders.events.v1

Consumer in another terminal/pod:

  bin/kafka-console-consumer.sh \
    --bootstrap-server prod-kafka-kafka-bootstrap:9092 \
    --topic orders.events.v1 \
    --from-beginning

Note: port 9092 is a local lab plain listener.
Use port 9093 with TLS auth for production-style applications.
INSTRUCTIONS

kubectl run kafka-client -n kafka -it --rm \
  --image=quay.io/strimzi/kafka:1.0.0-kafka-4.1.2 \
  --restart=Never -- bash
