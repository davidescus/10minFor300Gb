base:
  '*':
    - consul
    - prometheus-node-exporter

  '*-generator':
    - app-generator

  '*-consul':
    - consul-server

  '*-monitoring':
    - prometheus
