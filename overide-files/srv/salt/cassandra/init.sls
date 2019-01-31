include:
  - common.cassandra-package

# TODO find solution to scale on many machines
# TODO get network interfaces only for cassandra machines
{%- set interfaces = salt['mine.get']('*', 'network.interfaces') %}
{%- set  seedIp =  interfaces['server-cassandra-seed']['enp0s2']['inet'][0]['address'] %}
{%- set  nodeIp =  interfaces['server-cassandra-node']['enp0s2']['inet'][0]['address'] %}
{%- set serverName = grains['id'] %}

cassandra|config:
  file.managed:
    - name: /etc/cassandra/cassandra.yaml
    - source: salt://cassandra/files/cassandra.yaml
    - template: jinja
    - context:
      {% if serverName == "server-cassandra-node" %}
      nodeIp: {{ nodeIp }}
      {% else %}
      nodeIp: {{ seedIp }}
      {% endif %}
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
    {% if serverName == "server-cassandra-node" %}
    - check_cmd:
      - "nc -z {{ seedIp }} 9042; do sleep 1; done"
    {% endif %}
    - require:
      - service: cassandra|service-stop
