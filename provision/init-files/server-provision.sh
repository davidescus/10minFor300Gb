#!/usr/bin/env bash

# restart salt master
pkill salt-master
salt-master -d

# accept all minions
salt-key -A -y

# see if minions was accepted
salt-key

# send network interfaces for mine
salt '*' mine.send network.interfaces && salt '*' mine.send grains.items && salt '*' mine.update