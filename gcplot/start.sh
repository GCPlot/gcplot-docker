#!/bin/sh

# Start & Init OrientDB

sed -i "s/{GCPLOT_MEMORY}/$GCPLOT_MEMORY/g" /etc/init.d/gcserver \
  && sed -i "s/{ORIENTDB_MEMORY}/$ORIENTDB_MEMORY/g" /etc/init.d/orientdb \
  && sed -i "s/{CASSANDRA_MEMORY}/$CASSANDRA_MEMORY/g" /etc/cassandra/jvm.options

echo "Starting OrientDB ..."

service orientdb start

echo "Waiting for the OrientDB 2424 port to be opened ..."

while ! nc -z localhost 2424; do
  sleep 0.1 # wait for 1/10 of the second before check again
done

echo "Creating OrientDB database ..."

/opt/orientdb/bin/console.sh "CREATE DATABASE remote:localhost:2424/gcplot admin admin plocal"

# Start & Init Cassandra

echo "Starting Cassandra ..."

service cassandra start

echo "Waiting for the Cassandra 9042  port to be opened ..."

while ! nc -z localhost 9042; do
  sleep 0.1 # wait for 1/10 of the second before check again
done

while [ $(grep "Created default superuser role" /var/log/cassandra/debug.log | wc -l) -eq "0" ]; do
  sleep 0.1
done

echo "Performing CQL initialization ..."

cqlsh --username=cassandra --password=cassandra --file=/etc/cassandra/cdb.cql

echo "Running gcserver service ..."

service gcserver start

# Follow output

echo "GCPlot instance is initialized"

while [ $(grep "Trying to reload configuration from main DB" /home/gcserver/logs/app.debug.*.log | wc -l) -eq "0" ]; do
  sleep 0.1
done

echo "Registering admin user in GCPlot ..."

curl 127.0.0.1:9091/user/register_admin

echo "Starting nginx service ..."

service nginx start

tail -F /home/gcserver/logs/app.debug.*.log
