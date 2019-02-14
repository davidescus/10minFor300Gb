#!/usr/bin/env bash

salt '*' mine.send network.ipaddrs
salt '*' mine.send grains.items
salt '*' mine.update
