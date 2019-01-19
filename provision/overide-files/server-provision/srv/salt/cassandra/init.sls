cassandra|repo:
  pkgrepo.managed:
    - humanname: Cassandra Debian Repository
    - name: deb http://www.apache.org/dist/cassandra/debian 36x main
    - key_url: https://www.apache.org/dist/cassandra/KEYS
    - file: /etc/apt/sources.list.d/cassandra.list

cassandra|package:
  pkg.installed:
    - name: cassandra
    - require:
      - pkgrepo: cassandra|repo

cassandra|config:
  file.managed:
    - name: /etc/cassandra/cassandra.yaml
    - source: salt://cassandra/files/cassandra.yaml

cassandra|service:
  service.running:
    - name: cassandra
    - enable: True
    - require:
      - pkg: cassandra|package
      - file: /etc/cassandra/cassandra.yaml
