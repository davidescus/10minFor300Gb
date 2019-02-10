{% import_yaml 'config.yaml' as config %}

extract-prometheus-node-exporter:
  archive.extracted:
    - name: /root
    - source: https://github.com/prometheus/node_exporter/releases/download/v{{ config.node_exporter.version }}/node_exporter-{{ config.node_exporter.version }}.linux-amd64.tar.gz
    - skip_verify: True

node-exporter-systemd-unit:
  file.managed:
    - name: /etc/systemd/system/node-exporter.service
    - source: salt://prometheus-node-exporter/files/node-exporter.service
  module.wait:
    - name: service.systemctl_reload
    - onchanges:
      - file: node-exporter-systemd-unit
    - require:
      - extract-prometheus-node-exporter

node-exporter-running:
  service.running:
    - name: node-exporter
    - enable: True
    - watch:
      - module: node-exporter-systemd-unit