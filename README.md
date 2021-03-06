# GCPlot - All-in-one JVM GC Logs Analyzer

https://github.com/dmart28/gcplot

https://github.com/dmart28/gcplot-ui

GCPlot is a Java Garbage Collector (GC) logs analyzer. Basically, it's an effort to solve all GC logs reading/analyzing problems once and forever. As developers, we were tired about the current situation and efforts needed to just compare some number of GC configurations, so we decided to start from scratch and build a tool that suits best for us.

The report itself consists of a lot of graphs, measurements, stats, etc about how exactly your GC works. You can also manage the timeline and decide - whether to dig deeper, by analyzing, for example, 2 minutes interval in the most details, or check everything from the bird's eye view by choosing the last month.

# Installation

## Docker Installation

You can run GCPlot in a Docker container. Docker is supported by most of the modern OS, for more details check official [Docker Installation](https://docs.docker.com/engine/installation/) page.

In order to run GCPlot as-is without additional configuration, run next command:

`docker run -d -p 80:80 gcplot/gcplot`

After that eventually the platform will be accessible from your host machine at `http://127.0.0.1` address. If you would like to use another port, just change it. For example, for `http://127.0.0.1:8080` address, the command will look like:

`docker run -d -p 8080:80 gcplot/gcplot`

By default, admin user is already created, with username and password `admin`. Please consider changing it for the best security after the initial log in.

### Versions

You can check the Docker container versions available [here](https://hub.docker.com/r/gcplot/gcplot/tags/). 

### Memory Settings

You can control heap size of the services inside container. GCPlot uses Cassandra and OrientDB under the hood, which are also presented inside the container. Default values are:

```
GCPLOT_MEMORY=512m
ORIENTDB_MEMORY=256m
CASSANDRA_MEMORY=1g
```

To give, for example, GCPlot service 1G of heap, and to Cassandra 4G, the command may look like:

`docker run -d -p 80:80 -e "GCPLOT_MEMORY=1g" -e "CASSANDRA_MEMORY=4g" gcplot/gcplot`
