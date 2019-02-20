include:
  - common.cassandra-package

# create list with all seeds ips
{% set seedIps = [] -%}
{%- set seedIpAddresses = salt['mine.get']('cassandra-seed-*', 'network.ipaddrs').items() %}
{% if seedIpAddresses|length %}
{% for hostname, ip in seedIpAddresses %}
{% do seedIps.append(ip[0]) -%}
{% endfor %}
{% endif %}

# TODO check when add new server is it added into conf??
cassandra|config:
  file.managed:
    - name: /etc/cassandra/cassandra.yaml
    - source: salt://cassandra/files/cassandra.yaml
    - template: jinja
    - context:
      nodeIp: {{ salt['network.ipaddrs']()[0] }}
      seedIp: {{ seedIps | join(", ") }}

# TODO do not restart cassandra if already running
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
    {% if grains['id'].startswith('cassandra-node') %}
    - check_cmd:
      - "nc -z {{ seedIps[0] }} 9042; do sleep 1; done"
    {% endif %}
    - require:
      - service: cassandra|service-stop

# TODO automatically create keyspace and tables when run provision
cassandra|provision-schema-file:
  file.managed:
    - name: /root/provision-app-schema.cql
    - source: salt://cassandra/files/provision-app-schema.cql
