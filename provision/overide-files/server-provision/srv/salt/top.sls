base:
  '*':
    - prometheus-node-exporter
    - filebeat

  '*-generator':
    - app-generator

  '*-monitoring':
    - prometheus

  '*-elk':
    - java8
    - elasticsearch
    - kibana
