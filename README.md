# Production-Style Kafka KRaft

This repository provides a hands-on, production-oriented Kafka cluster running on a local Kubernetes cluster using the Strimzi Kafka Operator.

It is designed as a learning and portfolio project for Kafka platform engineering, SRE, and distributed systems operations.

## What This Deploys

- Kafka in KRaft mode, without ZooKeeper
- 3 dedicated KRaft controller nodes
- 3 dedicated Kafka broker nodes
- Persistent volumes for controllers and brokers
- Replication factor 3
- `min.insync.replicas=2`
- Internal TLS listener
- Strimzi Topic Operator and User Operator
- Kafka Exporter for consumer lag and topic metrics
- Example topic with production-style durability settings
- Example TLS-authenticated user with ACLs
- KinD cluster with 3 worker nodes for pod spread
- Prometheus and Grafana examples for observability

## Kafka Version

This lab targets:

```text
Kafka: 4.1.2
Strimzi Operator: 1.0.0+ via latest stable install bundle from strimzi.io
Strimzi CRD API: kafka.strimzi.io/v1
Mode: KRaft
```

Kafka 4.x is ZooKeeper-free. Metadata is managed by Kafka controller quorum instead of ZooKeeper.

## ZooKeeper to KRaft Mental Model

If you have operated ZooKeeper-backed Kafka:

| ZooKeeper Kafka | KRaft Kafka |
| --- | --- |
| ZooKeeper ensemble stores cluster metadata | KRaft controller quorum stores cluster metadata |
| ZooKeeper handles controller election | KRaft controller quorum elects controller leader |
| Brokers register with ZooKeeper | Brokers register with KRaft controllers |
| Topic metadata lives in ZooKeeper | Topic metadata lives in Kafka metadata log |
| Need to operate ZooKeeper and Kafka | Operate Kafka controllers and brokers |

In this repo:

```text
controller KafkaNodePool -> replaces ZooKeeper metadata/control-plane responsibilities
broker KafkaNodePool     -> stores topic partitions and serves client traffic
```

## Architecture

```text
KinD Cluster
├── control-plane
├── worker
├── worker
└── worker

kafka namespace
├── Strimzi Cluster Operator
├── prod-kafka-controller-0/1/2
├── prod-kafka-broker-0/1/2
├── KafkaTopic: orders.events.v1
├── KafkaUser: orders-app
└── Kafka Exporter
```

## Repository Layout

```text
kind/
  kind-config.yaml

manifests/
  strimzi/
    kafka-kraft-cluster.yaml
  topics/
    orders-topic.yaml
  users/
    orders-app-user.yaml
  monitoring/
    prometheus.yaml
    grafana.yaml

scripts/
  00-create-kind-cluster.sh
  01-install-strimzi.sh
  02-deploy-kafka.sh
  03-create-topic-user.sh
  04-smoke-test-plain.sh
  05-delete-broker-test.sh
  99-destroy-kind-cluster.sh

docs/
  production-notes.md
  zookeeper-to-kraft.md
```

## Prerequisites

Install:

- Docker Desktop
- `kind`
- `kubectl`

Optional:

- Helm
- `k9s`

## Quickstart

Create the KinD cluster:

```bash
./scripts/00-create-kind-cluster.sh
```

Install Strimzi:

```bash
./scripts/01-install-strimzi.sh
```

Deploy Kafka:

```bash
./scripts/02-deploy-kafka.sh
```

Create topic and user:

```bash
./scripts/03-create-topic-user.sh
```

Check resources:

```bash
kubectl get pods -n kafka -o wide
kubectl get kafka,kafkanodepool,kafkatopic,kafkauser -n kafka
kubectl get pvc -n kafka
```

## Smoke Test

The production-style listener is TLS-enabled. For a quick local learning test, the manifest also includes an internal plain listener on `9092`.

Run:

```bash
./scripts/04-smoke-test-plain.sh
```

This starts a temporary Kafka client pod and prints commands for producing and consuming messages.

## Failure Test

Delete one broker pod and watch recovery:

```bash
./scripts/05-delete-broker-test.sh
kubectl get pods -n kafka -w
```

Why this matters:

- Replication factor 3 keeps topic replicas available.
- `min.insync.replicas=2` protects acknowledged writes.
- KRaft controller quorum should remain healthy.

## Important Production Settings

```yaml
default.replication.factor: 3
min.insync.replicas: 2
offsets.topic.replication.factor: 3
transaction.state.log.replication.factor: 3
transaction.state.log.min.isr: 2
unclean.leader.election.enable: false
auto.create.topics.enable: false
```

Why:

- Replication factor 3 survives a broker failure.
- Min ISR 2 prevents writes when too few replicas are in sync.
- Disabling unclean leader election avoids data loss from out-of-sync replicas.
- Disabling auto topic creation prevents accidental topics with poor defaults.

## KinD Limitations

This is production-style, not real production.

KinD is limited by:

- single physical machine
- no real availability zones
- local-path storage
- no real rack awareness
- limited I/O realism
- no managed load balancer

Real production should add:

- multi-AZ Kubernetes node groups
- dedicated storage class
- rack awareness
- external listener design
- mTLS/SASL policy
- NetworkPolicies
- PodDisruptionBudgets
- Prometheus/Grafana dashboards
- backup and restore process
- GitOps deployment
- capacity planning and load testing

## Resume Bullet

```text
Built a production-style Kafka 4.1.2 KRaft cluster on Kubernetes using Strimzi, dedicated controller and broker node pools, persistent storage, replication factor 3, min ISR 2, TLS users, ACLs, KafkaTopic/KafkaUser CRDs, Kafka Exporter metrics, and failure testing on KinD.
```
