extract-app-generator:
  archive.extracted:
    - name: /root/app/generator
    - source: https://github.com/bgadrian/pseudoservice/releases/download/v2.0.0/pseudoservice.tar.gz
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
    - watch:
      - module: app-generator-systemd-unit
