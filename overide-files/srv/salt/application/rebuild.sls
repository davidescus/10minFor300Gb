{% import_yaml 'config.yaml' as config %}

app|remove:
  file.absent:
    - name: {{ config.etl.dir }}
    - order: first

include:
  - common.app-extract
