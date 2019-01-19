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

{%- set interfaces = salt['mine.get']('*', 'network.interfaces') %}
{%- set  elasticSearchIp =  interfaces['server-elasticsearch']['enp0s2']['inet'][0]['address'] %}

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
