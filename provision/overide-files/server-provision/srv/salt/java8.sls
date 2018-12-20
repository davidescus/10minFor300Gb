# add the oracle jvm ppa, and install java8
# https://launchpad.net/~webupd8team/+archive/ubuntu/java
# This is used for all java installs
# This is slightly retooled due to a bug in Salt 2014.7 (Helium)
# ... and to not use cmd.run
# https://gist.github.com/snarfmonkey/b7a1109ccbfcfcaf723e

oracle-ppa:
  pkgrepo.managed:
    - humanname: WebUpd8 Oracle Java PPA repository
    - name: deb http://ppa.launchpad.net/webupd8team/java/ubuntu bionic main
    - dist: bionic
    - file: /etc/apt/sources.list.d/webupd8team-java.list
    - keyid: EEA14886
    - keyserver: keyserver.ubuntu.com

oracle-license-select:
  debconf.set:
    - name: oracle-java8-installer
    - data:
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': 'true'}

oracle-java8-installer:
  pkg:
    - installed
    - require:
      - pkgrepo: oracle-ppa

