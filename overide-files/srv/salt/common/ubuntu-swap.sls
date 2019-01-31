create|swap-file:
  cmd.script:
    - name: create-swap-file
    - source: salt://common/files/create-swap-file.sh
    - onlyif: "[ $(free -m | grep Swap | awk '{print $2}') -eq 0 ]"
    - user: root
    - group: root
    - shell: /bin/bash