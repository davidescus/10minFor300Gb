elasticsearch_repo:
  pkgrepo.managed:
    - humanname: Elasticsearch Official Debian Repository
    - name: deb https://artifacts.elastic.co/packages/6.x/apt stable main
    - dist: stable
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - file: /etc/apt/sources.list.d/elasticsearch.list

elasticsearch:
  pkg:
    - installed
    - require:
      - pkgrepo: elasticsearch_repo
  service:
    - running
    - enable: True
    - require:
      - pkg: elasticsearch
      - file: /etc/elasticsearch/elasticsearch.yml

/etc/elasticsearch/elasticsearch.yml:
  file:
    - managed
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://elasticsearch/files/elasticsearch.yml
