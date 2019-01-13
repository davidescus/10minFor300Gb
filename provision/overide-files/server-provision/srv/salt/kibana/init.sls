include:
  - common.elastic-repo

kibana|package:
  pkg.installed:
    - name: kibana
    - require:
      - pkgrepo: elastic|repo

{% set pathToLogFile = '/var/log/kibana/kibana.log' %}

kibana|log-file:
  file.managed:
    - name: {{ pathToLogFile }}
    - makedirs: True
    - user: kibana
    - group: kibana
    - require:
      - pkg: kibana|package

kibana|service:
  service.running:
    - name: kibana
    - enable: True
    - require:
      - pkg: kibana|package
      - file: /etc/kibana/kibana.yml
      - file: {{ pathToLogFile }}

kibana|config:
  file.managed:
    - name: /etc/kibana/kibana.yml
    - template: jinja
    - source: salt://kibana/files/kibana.yml
