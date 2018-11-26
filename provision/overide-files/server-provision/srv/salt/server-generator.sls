extract-app:
  archive.extracted:
    - name: /root/app/generator
    - source: https://github.com/bgadrian/pseudoservice/releases/download/v2.0.0/pseudoservice.tar.gz
    - skip_verify: True

# be dure you have systemctl available
systemd:
  pkg.installed: []

# create service for app
app-generator-systemd-unit:
  file.managed:
    - name: /etc/systemd/system/app-generator.service
    - source: salt://unit-files/app-generator.service
  module.wait:
    - name: service.systemctl_reload
    - onchanges:
      - file: app-generator-systemd-unit
    - require:
      - file: app-generator-systemd-unit

# be sure app service is start
app-generator-running:
  service.running:
    - name: app-generator
    - watch:
      - module: app-generator-systemd-unit
    - require:
      - module: app-generator-systemd-unit
