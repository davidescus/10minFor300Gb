include:
  - common.elastic-repo

logstash|package:
  pkg.installed:
    - name: logstash
    - require:
      - pkgrepo: elastic|repo

{% set inputFile = '02-beats-input.conf' %}
{% set filterFile = '10-syslog-filter.conf' %}
{% set outputFile = '30-elasticsearch-output.conf' %}

logstash|config-input:
  file.managed:
    - name: /etc/logstash/conf.d/{{ inputFile }}
    - source: salt://logstash/files/{{ inputFile }}

logstash|config-filter:
  file.managed:
    - name: /etc/logstash/conf.d/{{ filterFile }}
    - source: salt://logstash/files/{{ filterFile }}

{%- set interfaces = salt['mine.get']('*', 'network.interfaces') %}
{%- set  elasticSearchIp =  interfaces['server-elasticsearch']['enp0s2']['inet'][0]['address'] %}

logstash|config-output:
  file.managed:
     - name: /etc/logstash/conf.d/{{ outputFile }}
     - source: salt://logstash/files/{{ outputFile }}
     - template: jinja
     - context:
       ipAddress: {{ elasticSearchIp }}

logstash|service:
  service.running:
    - name: logstash
    - enable: True
    - require:
      - pkg: logstash|package
      - file: /etc/logstash/conf.d/{{ inputFile }}
      - file: /etc/logstash/conf.d/{{ filterFile }}
      - file: /etc/logstash/conf.d/{{ outputFile }}
