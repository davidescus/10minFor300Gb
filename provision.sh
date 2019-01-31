#!/usr/bin/env bash

# restart salt master
./scripts/restart-master.sh

# accept all minions
./scripts/accept-keys.sh

# send network interfaces for mine
./scripts/prepare-mine.sh
