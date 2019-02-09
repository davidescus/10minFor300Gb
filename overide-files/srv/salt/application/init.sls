include:
  - common.app-extract

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

