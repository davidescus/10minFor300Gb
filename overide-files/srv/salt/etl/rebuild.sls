{% import_yaml 'config.yaml' as config %}

etl|remove:
  file.absent:
    - name: {{ config.etl.dir }}
    - order: first

include:
  - common.etl
