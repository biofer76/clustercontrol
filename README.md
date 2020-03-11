# ClusterControl for custom Docker databases

[ClusterControl](https://severalnines.com/product/clustercontrol) is an all-inclusive open source database management system for MySQL, MongoDB, and PostgreSQL with advanced monitoring and scaling features.

I created this repository to manage a databases cluster deployed with custom Docker images, in particular when you need to run a database with some extensions or already built-in configurations.

## Requirements:

- Docker Engine
- Docker Compose 3.5+

## Environment variables

All services require environment configuration, to accomplish this you must create two files in project root:
- `clustercontrol.env`
- `postgres.env`

Each file contains environment configuration for its service.

`clustercontrol.env`
```
CMON_PASSWORD_FILE=password1
MYSQL_ROOT_PASSWORD_FILE=password2
```

`postgres.env`
```
AUTO_DEPLOYMENT=0
POSTGRES_USER=pguser
POSTGRES_DBNAME=postgisdb
POSTGRES_PASS=password3
```

For the full list of available variables and default values please check respective projects on GitHub:

- [severalnines/docker](https://github.com/severalnines/docker)
- [kartoza/postgis:9.6-2.4](https://github.com/kartoza/docker-postgis)

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


