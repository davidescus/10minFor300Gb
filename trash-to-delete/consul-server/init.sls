{% set consulMasterKey = salt['cmd.run']('consul keygen') %}

# TODO solve this problem with key here
/root/testKey:
  file.managed:
    - contents:
      - {{consulMasterKey}}
