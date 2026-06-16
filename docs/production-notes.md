# Production Notes

This repo is production-style for learning, but KinD is not production.

## Production Patterns Included

- Strimzi Operator manages Kafka lifecycle
- KRaft mode avoids ZooKeeper
- dedicated controller and broker node pools
- persistent storage
- replication factor 3
- min ISR 2
- unclean leader election disabled
- auto topic creation disabled
- explicit topic CRDs
- TLS user example
- ACL example
- Kafka Exporter
- failure test script

## What Real Production Needs

- multi-AZ Kubernetes node groups
- rack awareness
- dedicated storage class
- PodDisruptionBudgets
- NetworkPolicies
- external listener design
- mTLS or SASL policy
- secrets management
- backup and restore testing
- GitOps deployment
- capacity planning
- load testing
- Grafana dashboards
- alerting rules
- client producer/consumer standards

## Recommended Producer Defaults

```properties
acks=all
enable.idempotence=true
retries=2147483647
delivery.timeout.ms=120000
request.timeout.ms=30000
linger.ms=5
compression.type=lz4
```

## Recommended Consumer Practices

```properties
enable.auto.commit=false
max.poll.records=500
session.timeout.ms=45000
heartbeat.interval.ms=15000
auto.offset.reset=earliest
```

## Important SRE Checks

- broker pod health
- controller quorum health
- partition under-replication
- offline partitions
- ISR shrink/expand events
- consumer lag
- produce latency
- fetch latency
- disk usage
- network throughput
- request handler saturation

