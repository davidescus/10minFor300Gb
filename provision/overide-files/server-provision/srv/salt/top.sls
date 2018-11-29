base:
  '*':
    - systemd
    - prometheus-node-exporter

  '*-generator':
    - app-generator

  '*-monitoring':
    - prometheus
