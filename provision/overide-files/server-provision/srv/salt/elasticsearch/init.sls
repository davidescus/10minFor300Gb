elastic|repo:
  pkgrepo.managed:
    - humanname: Elasticsearch Official Debian Repository
    - name: deb https://artifacts.elastic.co/packages/6.x/apt stable main
    - dist: stable
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - file: /etc/apt/sources.list.d/elasticsearch.list

elasticsearch|package:
  pkg.installed:
    - name: elasticsearch
    - require:
      - pkgrepo: elastic|repo

elasticsearch|service:
  service.running:
    - name: elasticsearch
    - enable: True
    - require:
      - pkg: elasticsearch|package
      - file: /etc/elasticsearch/elasticsearch.yml

elasticsearch|config:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - template: jinja
    - source: salt://elasticsearch/files/elasticsearch.yml
