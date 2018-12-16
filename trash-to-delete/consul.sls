extract-consul:
  archive.extracted:
    - name: /usr/local/bin
    - source: https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip
    - skip_verify: True
    - enforce_toplevel: False

{% set consulDirectories = ['/etc/consul.d/bootstrap', '/etc/consul.d/server', '/etc/consul.d/client', '/var/consul'] %}

{% for dir in consulDirectories %}
{{dir}}:
{% if not salt['file.directory_exists' ]('{{dir}}') %}
  file.directory:
    - user: root
    - name: {{dir}}
    - group: root
    - mode: 755
    - makedirs: True
{% else %}
  cmd.run:
    - name: echo "Directory '{{dir}}' already exists"
{% endif %}
{% endfor %}
