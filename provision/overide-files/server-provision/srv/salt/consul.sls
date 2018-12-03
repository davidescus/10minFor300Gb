extract-consul:
  archive.extracted:
    - name: /usr/local/bin
    - source: https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip
    - skip_verify: True
    - enforce_toplevel: False
