app|extract-generator:
  archive.extracted:
    - name: /root/app
    - source: https://github.com/davidescus/request-parser/releases/download/v.0.0.0/request-parser.tar.gz
    - skip_verify: True
    - enforce_toplevel: False

{%- set interfaces = salt['mine.get']('*', 'network.interfaces') %}

{%- set  generatorIp =  interfaces['server-generator']['enp0s2']['inet'][0]['address'] %}
app|generator-host:
   file.append:
     - name: /etc/environment
     - text: 'export GENERATOR_HOST={{ generatorIp }}'

{%- set  storageIp =  interfaces['server-cassandra-seed']['enp0s2']['inet'][0]['address'] %}
app|storage-host:
   file.append:
     - name: /etc/environment
     - text: 'export STORAGE_HOST={{ storageIp }}'