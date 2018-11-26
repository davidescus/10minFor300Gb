packages:
  pkg.installed:
    - pkgs:
      - make
      - gcc

git:
  pkg.installed

https://github.com/bgadrian/pseudoservice.git:
  git.latest:
    - rev: master
    - target: /root/generator
    - user: root
    - require:
      - pkg: git
  cmd.run:
    - cwd: /root/generator/
    - name: make build
#    - env:
#      - "PATH=$PATH:/usr/local/golang/1.11.2/go/bin"
