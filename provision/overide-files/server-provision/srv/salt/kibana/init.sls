include:
  - common.elastic-repo

kibana|package:
  pkg.installed:
    - name: kibana
    - require:
      - pkgrepo: elastic|repo

{% set pathToLogFile = '/var/log/kibana/kibana.log' %}

kibana|log-file:
  file.managed:
    - name: {{ pathToLogFile }}
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
      - file: {{ pathToLogFile }}
