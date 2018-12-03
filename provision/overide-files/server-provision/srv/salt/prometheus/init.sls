extract-prometheus:
  archive.extracted:
    - name: /root
    - source: https://github.com/prometheus/prometheus/releases/download/v2.5.0/prometheus-2.5.0.linux-amd64.tar.gz
    - skip_verify: True

prometheus-systemd-unit:
  file.managed:
    - name: /etc/systemd/system/prometheus.service
    - source: salt://prometheus/files/prometheus.service
  module.wait:
    - name: service.systemctl_reload
    - onchanges:
      - file: prometheus-systemd-unit
    - require:
      - extract-prometheus

# TODO use Consul for service discovery

prometheus-running:
  service.running:
    - name: prometheus
    - enable: True
    - watch:
      - module: prometheus-systemd-unit