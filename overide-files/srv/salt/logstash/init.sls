include:
  - common.elastic-repo

logstash|package:
  pkg.installed:
    - name: logstash
    - require:
      - pkgrepo: elastic|repo

logstash|config:
  file.managed:
    - name: /etc/logstash/logstash.yml
    - source: salt://logstash/files/logstash.yml

# TODO deal with many machines
{%- set ips = salt['mine.get']('elasticsearch-*', 'network.ipaddrs') %}
{%- set  elasticSearchIp =  ips['elasticsearch-1'][0] %}

logstash|pipeline-config:
  file.managed:
     - name: /etc/logstash/conf.d/pipeline.conf
     - source: salt://logstash/files/pipeline.conf
     - template: jinja
     - context:
       ipAddress: {{ elasticSearchIp }}

logstash|service:
  service.running:
    - name: logstash
    - enable: True
    - require:
      - pkg: logstash|package
      - file: /etc/logstash/conf.d/pipeline.conf
      - file: /etc/logstash/logstash.yml
