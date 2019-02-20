{% import_yaml 'config.yaml' as config %}

include:
  - common.elastic-repo

kibana|package:
  pkg.installed:
    - name: kibana
    - require:
      - pkgrepo: elastic|repo

kibana|log-file:
  file.managed:
    - name: {{ config.kibana.log_file }}
    - makedirs: True
    - runas: kibana
    - require:
      - pkg: kibana|package

# TODO deal with multiple elasticsearch machines
{%- set ips = salt['mine.get']('elasticsearch-*', 'network.ipaddrs') %}
{%- set  elasticSearchIp =  ips['elasticsearch-1'][0] %}

kibana|config:
  file.managed:
    - name: /etc/kibana/kibana.yml
    - source: salt://kibana/files/kibana.yml
    - template: jinja
    - context:
      ipAddress: {{ elasticSearchIp }}

kibana|service:
  service.running:
    - name: kibana
    - enable: True
    - require:
      - pkg: kibana|package
      - file: /etc/kibana/kibana.yml
      - file: {{ config.kibana.log_file }}
