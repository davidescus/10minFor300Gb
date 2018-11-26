#systemd:
#  - service.running:
#    - enabled: True

extract-app:
  archive.extracted:
    - name: /root/app/generator
    - source: https://github.com/bgadrian/pseudoservice/releases/download/v2.0.0/pseudoservice.tar.gz
    - skip_verify: True

/etc/systemd/system/app-generator.service:
  file.managed:
    - contents: |

      [Unit]
      Description=Pseudoservicedatagenerator
      After=network.target
      StartLimitIntervalSec=0

      [Service]
      Type=simple
      Restart=always
      RestartSec=1
      User=root
      ExecStart=/root/app/generator/./pseudoservice/linux/pseudoservice --read-timeout=1s --write-timeout=1s --keep-alive=15s --listen-limit=1024 --max-header-size=3KiB --host=0.0.0.0 --port=8080

      [Install]
      WantedBy=multi-user.target

service.systemctl_reload:
  module.run:
    - onchanges:
      - file: /etc/systemd/system/app-generator.service

app-generator-service:
  service.running:
    - name: app-generator
    - enable: True
    - reload: True

#run-app:
#  cmd.run:
#    - name: systemctl enable app-generator
#    - require:
#      - systemd
#      - extract-app

#run-app-on-boot:
#  cmd.run:
#    - name: systemctl enable app-generator
#    - require:
#      - run-app

#install-app:
#  cmd.run:
#    - name: |
#        cd /tmp
#        wget -c https://github.com/bgadrian/pseudoservice/releases/download/v2.0.0/pseudoservice.tar.gz
#        tar xzf pseudoservice.tar.gz
#        cd pseudoservice/linux
#        ./pseudoservice/linux/pseudoservice --read-timeout=1s --write-timeout=1s --keep-alive=15s --listen-limit=1024 --max-header-size=3KiB --host=0.0.0.0 --port=8080
#    - cwd: /tmp
#    - shell: /bin/bash
#    - timeout: 300
#    - unless: test -x /usr/local/bin/foo
