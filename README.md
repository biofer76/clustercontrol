# ClusterControl for custom databases in Docker containers

[ClusterControl](https://severalnines.com/product/clustercontrol) is an all-inclusive open source database management system for MySQL, MongoDB, and PostgreSQL with advanced monitoring and scaling features.

I created this repository to manage a databases cluster deployed with custom Docker images, in particular when you need to run a database with some extensions or already built-in configurations.

## Requirements:

- Docker Engine
- Docker Compose 3.5+

## Manage Secrets

If you want to use Docker containers in production, chances are you’ll want to store your credentials in a secure way.  

### ClusterControl secrets

You must set MySQL root password and CMON Component password
```
echo "password1"| docker secret create CC_CMON_PASSWORD -
echo "password2"| docker secret create CC_MYSQL_ROOT_PASSWORD -
```

In this project I'm using [kartoza/postgis:9.6-2.4](https://hub.docker.com/r/kartoza/postgis) Docker image from Docker hub, it includes **PostgreSQL 9.6** and **PostGIS extension version 2.4**.

It requires default variables for databases initialization, I suggest to use at least PostgreSQL database password as secret, you just have to run:
```
echo "password3"| docker secret create POSTGRES_PASS -
```

You can choose to set more secrets or use environment variables in plain text format in Docker Compose file.

After secrets creation you can list them through listing command:
```
docker secret ls

ID                          NAME                     DRIVER              CREATED             UPDATED
auxdxxtivkm9u9243gir2a70y   CC_CMON_PASSWORD                             5 seconds ago       5 seconds ago
t0xrvb0hmlcpoo3xd6fd2p20u   CC_MYSQL_ROOT_PASSWORD                       4 seconds ago       4 seconds ago
wfptqxlun4jeusutcgs2h3hoa   POSTGRES_PASS                                3 seconds ago       3 seconds ago
```

For the full list of available variables and default values please check original project: [kartoza/postgis:9.6-2.4](https://hub.docker.com/r/kartoza/postgis)

## How it works

First of all you have to build the PostGIS database Docker image, it starts from `kartoza/postgis:9.6-2.4` image and then adds all required packages to work with ClusterControl.

I created a new `entrypoint.sh` as bash scripts wrapper in order to include entrypoint files from `kartoza/postgis:9.6-2.4` and `clustercontrols` Docker projects.

Build the  master PostGIS Docker image:
```
docker-compose build pg_master 
```

When new image postgis:9.6-2.4 is be ready, you can launch your ClusterControl databases manager and a cluster of PostGIS databases, cluster includes:

- 1 PostGIS Master node
- 2 PostGIS Slave nodes

Run Docker containers stack with Docker Compose command:

```
docker-compose -p dbc up
```

I used `-p dbc` argument to create a project name (dbc) for my new cluster, first command run containers stack in foreground, run in background with `-d` argument:

```
docker-compose -p dbc up -d
```

Stop and remove your all containers with:

```
docker-compose -p dbc down
```

All important data, as well postgresql data, are stored and will be kept as persistent data in Docker volumes.  

You can check `docker-compose.yml` file to see which folders are set as Docker volume.

If you restart cluster stack all data will be available as before, in case you want to wipe all data in persistent volumes run the command:

```
docker volume prune
```

## Manage Databases with ClusterControl

Open to ClusterControl Dashboard through the web address: http://server-ip-or-hostname:5000/clustercontrol  
Now you can configure a new cluster and import PostGIS nodes.

In order to configure your cluster please follow official guide on Severalnines website: https://severalnines.com/

--------------------------------
MIT License


