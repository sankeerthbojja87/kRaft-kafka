# ZooKeeper to KRaft Correlation

Kafka used ZooKeeper for metadata and controller coordination.

Modern Kafka uses KRaft.

## What Changed

| Topic | ZooKeeper Mode | KRaft Mode |
| --- | --- | --- |
| Metadata storage | ZooKeeper znodes | Kafka metadata log |
| Controller election | ZooKeeper | KRaft quorum |
| Broker registration | ZooKeeper | KRaft controllers |
| Topic metadata | ZooKeeper | KRaft metadata log |
| Operational burden | Kafka + ZooKeeper | Kafka controllers + brokers |

## How To Think About It

ZooKeeper ensemble:

```text
zk-0
zk-1
zk-2
```

KRaft controller quorum:

```text
prod-kafka-controller-0
prod-kafka-controller-1
prod-kafka-controller-2
```

Kafka brokers still do broker work:

```text
prod-kafka-broker-0
prod-kafka-broker-1
prod-kafka-broker-2
```

## Why Separate Controllers and Brokers

For production-style setups, separating roles gives:

- cleaner failure domains
- less noisy metadata/control-plane behavior
- easier capacity planning
- closer alignment to larger Kafka deployments

For tiny dev clusters, combined broker/controller nodes are possible, but this repo intentionally models a production-style layout.

