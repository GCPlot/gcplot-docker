#!/bin/sh

service orientdb start
service cassandra start
while ! nc -z localhost 2424; do
  sleep 0.1 # wait for 1/10 of the second before check again
done
while ! nc -z localhost 2424; do
  sleep 0.1 # wait for 1/10 of the second before check again
done

/opt/orientdb/bin/console.sh "CREATE DATABASE remote:localhost:2424/gcplot admin admin plocal"
tail -F /var/log/orientdb/orientdb.err
