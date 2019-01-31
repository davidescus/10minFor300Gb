base:
  '*':
    - prometheus-node-exporter
    - filebeat

  '*-generator':
    - app-generator

  '*-monitoring':
    - prometheus

  '*-elasticsearch':
    - common.ubuntu-swap
    - java8
    - elasticsearch

  '*-kibana':
    - common.ubuntu-swap
    - java8
    - kibana

  '*-logstash':
    - common.ubuntu-swap
    - java8
    - logstash

  '*-cassandra-seed':
    - common.ubuntu-swap
    - java8
    - cassandra.seed

  '*-cassandra-node':
      - common.ubuntu-swap
      - java8
      - cassandra.node