#
# GCPlot all-in-one dockerfile
#

FROM openjdk:8-jdk

ENV GCPLOT_VERSION=2.0
ENV CASSANDRA_VERSION=311x
ENV ORIENTDB_VERSION=2.2.13

ARG GCPLOT_MEMORY=512m
ARG ORIENTDB_MEMORY=256m
ARG CASSANDRA_MEMORY=1g

# Install packages and create appropriate user

RUN \
  apt-get update -y \
  && apt-get install -y wget curl python unzip nginx net-tools netcat \
  && groupadd --system gcserver \
  && useradd -d /home/gcserver -u 1040 -g gcserver -s /bin/bash gcserver \
  && mkdir -p /home/gcserver \
  && mkdir -m 755 -p /home/gcserver/logs \
  && mkdir -m 755 -p /home/gcserver/config \
  && mkdir -m 755 -p /home/gcserver/lib \
  && mkdir -m 777 -p /tmp/gcserver-file-uploads \
  && chown gcserver:gcserver /tmp/gcserver-file-uploads \
  && chown -R gcserver:gcserver /home/gcserver

COPY gcserver/logback.xml /home/gcserver/config
COPY gcserver/gcplot.properties /home/gcserver/config
COPY gcserver/gcserver /etc/init.d

RUN sed -i "s/{GCPLOT_MEMORY}/$GCPLOT_MEMORY/g" /etc/init.d/gcserver \
  && chmod 755 /etc/init.d/gcserver \
  && chmod -R 755 /home/gcserver/config/*

RUN \
  wget "https://downloads.gcplot.com/artifacts/gcserver/${GCPLOT_VERSION}/com.gcplot.web-${GCPLOT_VERSION}-all.jar" -O /home/gcserver/lib/bootstrap.jar \
  && chown -R gcserver:gcserver /home/gcserver

# Install OrientDB

RUN \
  groupadd --system orientdb \
  && useradd -d /var/orientdb -u 1041 -g orientdb -s /bin/bash orientdb \
  && mkdir -p /var/orientdb \
  && mkdir -p /var/lib/orientdb \
  && mkdir -p /var/log/orientdb \
  && chown -R orientdb:orientdb /var/orientdb \
  && chown -R orientdb:orientdb /var/lib/orientdb \
  && chown -R orientdb:orientdb /var/log/orientdb \
  && wget "http://orientdb.com/download.php?file=orientdb-community-$ORIENTDB_VERSION.tar.gz&os=multi" -O /tmp/orientdb.tar.gz \
  && tar -zvxf /tmp/orientdb.tar.gz --directory /opt \
  && mv /opt/orientdb-community-$ORIENTDB_VERSION /opt/orientdb \
  && chown -R orientdb:orientdb /opt/orientdb

COPY orientdb/orientdb-server-config.xml /opt/orientdb/config/orientdb-server-config.xml
COPY orientdb/orientdb-server-log.properties /opt/orientdb/config/orientdb-server-log.properties
COPY orientdb/orientdb.sh /opt/orientdb/bin/orientdb.sh

RUN cp /opt/orientdb/bin/orientdb.sh /etc/init.d/orientdb \
  && chmod 755 /etc/init.d/orientdb \
  && sed -i "s/{ORIENTDB_MEMORY}/$ORIENTDB_MEMORY/g" /etc/init.d/orientdb

# Install Cassandra

RUN echo "deb http://www.apache.org/dist/cassandra/debian $CASSANDRA_VERSION main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list \
  && curl https://www.apache.org/dist/cassandra/KEYS | apt-key add - \
  && apt-get update -y \
  && apt-get install cassandra -y \
  && sed -i '/ulimit/d' /etc/init.d/cassandra

COPY cassandra/cassandra-rackdc.properties /etc/cassandra/cassandra-rackdc.properties
COPY cassandra/cassandra-topology.properties /etc/cassandra/cassandra-topology.properties
COPY cassandra/cassandra.yaml /etc/cassandra/cassandra.yaml
COPY cassandra/jvm.properties /etc/cassandra/jvm.options
COPY cassandra/cdb.cql /etc/cassandra/cdb.cql
COPY start.sh /start.sh

RUN sed -i "s/{CASSANDRA_MEMORY}/$CASSANDRA_MEMORY/g" /etc/cassandra/jvm.options \
  && chmod 755 /start.sh

# Install UI



# Configuring nginx

COPY nginx/gcplot.conf /etc/nginx/sites-available/gcplot.conf
RUN ln -s /etc/nginx/sites-available/gcplot.conf /etc/nginx/sites-enabled/gcplot.conf \
  && rm -rf /etc/nginx/sites-enabled/default \
  && rm -rf /etc/nginx/sites-available/default

VOLUME ["/var/lib/cassandra", "/var/lib/orientdb"]
EXPOSE 2480 9090
CMD ["/start.sh"]
