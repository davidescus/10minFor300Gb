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
    - user: kibana
    - group: kibana
    - require:
      - pkg: kibana|package

{%- set interfaces = salt['mine.get']('*', 'network.interfaces') %}
{%- set  elasticSearchIp =  interfaces['server-elasticsearch']['enp0s2']['inet'][0]['address'] %}

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
