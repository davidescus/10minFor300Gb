#!/usr/bin/env bash

# create cassandra keyspace and table
# TODO deal with many cassandra seed (maybe a loop ???)
salt cassandra-seed-1 cmd.run 'cqlsh -f /root/provision-app-schema.cql'
