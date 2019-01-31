include:
  - common.cassandra-package

{%- set interfaces = salt['mine.get']('*', 'network.interfaces') %}
{%- set  seedIp =  interfaces['server-cassandra-seed']['enp0s2']['inet'][0]['address'] %}

cassandra|config:
  file.managed:
    - name: /etc/cassandra/cassandra.yaml
    - source: salt://cassandra/files/cassandra.yaml
    - template: jinja
    - context:
      nodeIp: {{ seedIp }}
      seedIp: {{ seedIp }}

cassandra|service-stop:
  service.dead:
    - name: cassandra
    - sig: cassandra
    - require:
      - pkg: cassandra|package
      - file: /etc/cassandra/cassandra.yaml

cassandra|service:
  cmd.run:
    - name: rm -rf /var/lib/cassandra/data/system/*
  service.running:
    - name: cassandra
    - enable: True
    - require:
      - pkg: cassandra|package
      - file: /etc/cassandra/cassandra.yaml
