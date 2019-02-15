base:
  '*':
    - prometheus-node-exporter
    - filebeat

  'monitoring-*':
    - prometheus

  'elasticsearch-*':
    - common.ubuntu-swap
    - java8
    - elasticsearch

  'kibana-*':
    - common.ubuntu-swap
    - java8
    - kibana

  'logstash-*':
    - common.ubuntu-swap
    - java8
    - logstash

  'cassandra-*':
    - common.ubuntu-swap
    - java8
    - cassandra

  'etl-*':
    - etl

  'generator-*':
    - app-generator