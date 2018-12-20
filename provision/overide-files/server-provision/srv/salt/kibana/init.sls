include:
  - common.elastic-repo

kibana|package:
  pkg.installed:
    - name: kibana
    - require:
      - pkgrepo: elastic|repo

kibana|service:
  service.running:
    - name: kibana
    - enable: True
    - require:
      - pkg: kibana|package
      - file: /etc/kibana/kibana.yml

kibana|config:
  file.managed:
    - name: /etc/kibana/kibana.yml
    - template: jinja
    - source: salt://kibana/files/kibana.yml
