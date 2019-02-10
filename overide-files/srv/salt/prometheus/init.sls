{% import_yaml 'config.yaml' as config %}

# grab all network interfaces and create config files for each machine
{%- set interfaces = salt['mine.get']('*', 'network.interfaces') %}
{%- if interfaces is defined %}
{%- for name, ifaces in interfaces.items() %}
prometheus|deploy-target-{{ name }}:
  file.managed:
    - name: /root/prometheus-targets/{{ name }}.json
    - source: salt://prometheus/target.json
    - makedirs: True
    - template: jinja
    - context:
      ipAddress: {{ ifaces['enp0s2']['inet'][0]['address'] }}
{% endfor %}
{% endif %}

prometheus|extract:
  archive.extracted:
    - name: /root
    - source: https://github.com/prometheus/prometheus/releases/download/v{{ config.prometheus.version }}/prometheus-{{ config.prometheus.version }}.linux-amd64.tar.gz
    - skip_verify: True

prometheus|deploy-config:
  file.managed:
    - name: /root/prometheus-{{ config.prometheus.version }}.linux-amd64/prometheus.yml
    - source: salt://prometheus/prometheus.yml

prometheus|systemd-unit:
  file.managed:
    - name: /etc/systemd/system/prometheus.service
    - source: salt://prometheus/files/prometheus.service
  module.wait:
    - name: service.systemctl_reload
    - onchanges:
      - file: prometheus|systemd-unit
    - require:
      - prometheus|extract

prometheus|running:
  service.running:
    - name: prometheus
    - enable: True
    - watch:
      - module: prometheus|systemd-unit