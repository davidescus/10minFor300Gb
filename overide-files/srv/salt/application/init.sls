# TODO create separate procedure for init and update, do not remove application every time
app|remove:
  file.absent:
    - name: /root/app

app|extract:
  archive.extracted:
    - name: /root/app
    - source: https://github.com/davidescus/request-parser/releases/download/v0.1.0/request-parser.tar.gz
    - skip_verify: True
    - enforce_toplevel: False

{%- set interfaces = salt['mine.get']('*', 'network.interfaces') %}

{%- set  generatorIp =  interfaces['server-generator']['enp0s2']['inet'][0]['address'] %}
app|set-generator-host:
   file.append:
     - name: /etc/environment
     - text: 'export GENERATOR_HOST={{ generatorIp }}'

{%- set  storageIp =  interfaces['server-cassandra-seed']['enp0s2']['inet'][0]['address'] %}
app|set-storage-host:
   file.append:
     - name: /etc/environment
     - text: 'export STORAGE_HOST={{ storageIp }}'

