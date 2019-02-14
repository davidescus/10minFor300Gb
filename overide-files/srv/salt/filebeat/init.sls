# it will worls only on debina family
# https://github.com/bougie/salt-filebeat-formula/

{%- set interfaces = salt['mine.get']('logstash-*', 'network.ipaddrs') %}
{% if interfaces|length %}
# TODO implement multiple logstash machines
{%- set logstashIp =  interfaces['logstash-1'][0] %}
pkg|apt-transport-https:
  pkg.latest:
    - name: apt-transport-https

filebeat|repo:
  pkgrepo.managed:
    - humanname: Filebeat Repository
    - name: deb https://artifacts.elastic.co/packages/6.x/apt stable main
    - dist: stable
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - file: /etc/apt/sources.list.d/beats.list
    - gpgcheck: 1
    - refresh_db: True
    - require:
      - pkg: pkg|apt-transport-https

filebeat|package:
  pkg.installed:
    - name: filebeat
    - require:
      - pkgrepo: filebeat|repo

filebeat|config:
  file.managed:
    - name: /etc/filebeat/filebeat.yml
    - source: salt://filebeat/files/filebeat.yml
    - template: jinja
    - context:
      ipAddress: {{ logstashIp }}

filebeat|service:
  service.running:
    - name: filebeat
    - enable: True
{% endif %}