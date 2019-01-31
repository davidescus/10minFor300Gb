#!/usr/bin/env bash

salt '*' mine.send network.interfaces
salt '*' mine.send grains.items
salt '*' mine.update
