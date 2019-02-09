#!/usr/bin/env bash

# create cassandra keyspace and table
salt server-cassandra-seed cmd.run 'cqlsh -f /root/provision-app-schema.cql'
