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

#golang-go:
#  archive.extracted:
#    - name: /usr/local
#    - source: https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz
#    - source_hash: 1dfe664fa3d8ad714bbd15a36627992effd150ddabd7523931f077b3926d736d
#  file.append:
#    - name: /root/.profile
#    - text: export PATH=$PATH:/usr/local/go/bin
