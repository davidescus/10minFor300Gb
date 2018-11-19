#!/usr/bin/env bash

# TODO apt-get update and apt-date upgrade

# restart salt master
pkill salt-master
salt-master -d

# accept all minions
salt-key -A -y

# see if minions was accepted
salt-key
