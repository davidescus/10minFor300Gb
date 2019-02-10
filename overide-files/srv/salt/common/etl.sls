{% import_yaml 'config.yaml' as config %}

app|extract:
  archive.extracted:
    - name: {{ config.etl.dir }}
    - source: https://github.com/davidescus/request-parser/releases/download/{{ config.etl.version }}/request-parser.tar.gz
    - skip_verify: True
    - enforce_toplevel: False