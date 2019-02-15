include:
  - common.elastic-repo

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
    - source: salt://elasticsearch/files/elasticsearch.yml
