{% import_yaml 'config.yaml' as config %}

extract-app-generator:
  archive.extracted:
    - name: {{ config.generator.dir }}
    - source: https://github.com/bgadrian/pseudoservice/releases/download/{{ config.generator.version }}/pseudoservice.tar.gz
    - skip_verify: True

app-generator-systemd-unit:
  file.managed:
    - name: /etc/systemd/system/app-generator.service
    - source: salt://app-generator/files/app-generator.service
  module.wait:
    - name: service.systemctl_reload
    - onchanges:
      - file: app-generator-systemd-unit
    - require:
      - extract-app-generator

app-generator-running:
  service.running:
    - name: app-generator
    - enable: True
    - watch:
      - module: app-generator-systemd-unit
