elastic|repo:
  pkgrepo.managed:
    - humanname: Elasticsearch Official Debian Repository
    - name: deb https://artifacts.elastic.co/packages/6.x/apt stable main
    - dist: stable
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - file: /etc/apt/sources.list.d/elasticsearch.list