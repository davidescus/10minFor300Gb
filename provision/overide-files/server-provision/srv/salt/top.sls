base:
  '*':
    - prometheus-node-exporter
    - filebeat

  '*-generator':
    - app-generator

  '*-monitoring':
    - prometheus
