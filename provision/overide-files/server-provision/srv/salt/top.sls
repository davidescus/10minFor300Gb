base:
  '*':
    - prometheus-node-exporter

  '*-generator':
    - app-generator

  '*-consul':
    - consul

  '*-monitoring':
    - prometheus
