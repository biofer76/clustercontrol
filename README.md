# ClusterControl for custom Docker databases

[ClusterControl](https://severalnines.com/product/clustercontrol) is an all-inclusive open source database management system for MySQL, MongoDB, and PostgreSQL with advanced monitoring and scaling features.

I created this repository to manage a databases cluster deployed with custom Docker images, in particular when you need to run a database with some extensions or already built-in configurations.

## Requirements:

- Docker Engine
- Docker Compose 3.5+

## Environment variables

All services require environment configuration, to accomplish this you must create three files in project root:
- `clustercontrol.env`
- `postgres.env`
- `postgres_replicator.env`

Each file contains environment configuration for its service.

Create a new file `clustercontrol.env` then copy and paste following variables and change default values.
```
CMON_PASSWORD_FILE=password1
MYSQL_ROOT_PASSWORD_FILE=password2
```

Create a new file `postgres.env` then copy and paste following variables and change `POSTGRES_USER` and `POSTGRES_PASS` default values.
```
AUTO_DEPLOYMENT=0
POSTGRES_USER=pguser
POSTGRES_DBNAME=postgisdb
POSTGRES_PASS=password3
```

Create a new file `postgres_replicator.env` then copy and paste following variables and set `POSTGRES_USER` and `POSTGRES_PASS` as you did in `postgres.env`
```
AUTO_DEPLOYMENT=0
POSTGRES_USER=pguser
POSTGRES_PASS=password3
ALLOW_IP_RANGE=0.0.0.0/0s
REPLICATE_FROM=pg_master
```

For the full list of available variables and default values please check respective projects on GitHub:

- [severalnines/docker](https://github.com/severalnines/docker)
- [kartoza/postgis:9.6-2.4](https://github.com/kartoza/docker-postgis)

## How it works

First of all you have to build the PostGIS database Docker image, it starts from `kartoza/postgis:9.6-2.4` image and then build process will add all required packages to work with ClusterControl.

I created a new `entrypoint.sh` as bash scripts wrapper in order to include all entrypoint files from `kartoza/postgis:9.6-2.4` and `clustercontrols` Docker projects.

Build the  master PostGIS Docker image:
```
docker-compose build pg_master 
```

When the new image `postgis:9.6-2.4` is ready, you can run the ClusterControl databases manager and a cluster of PostgreSQL + PostGIS databases, cluster includes:

- 1 PostGIS Master node (read-write)
- 2 PostGIS Slave nodes (read-only)

Run Docker containers stack with Docker Compose command:
```
docker-compose -p dbc up
```

I used `-p dbc` argument to create a project name prefix (dbc) for my new cluster, the previous command runs containers stack in foreground and shows logs, to run in background add `-d` argument:
```
docker-compose -p dbc up -d
```

Stop and remove your all containers with:
```
docker-compose -p dbc down
```

All important data, as well PostgreSQL data, will be kept in Docker volumes and stored as persistent data.

You will find several Docker volumes in your system, check new volumes:
```
docker volume ls
```

The persistent volumes are:

- `/etc/cmon.d` - ClusterControl configuration files.
- `/var/lib/mysql` - MySQL datadir to host cmon and dcps database.
- `/root/.ssh` - SSH private and public keys.
- `/var/lib/cmon` - ClusterControl internal files.
- `/root/backups` - Default backup directory only if ClusterControl is the backup destination
- `pg_master` - Master PostgreSQL datadir
- `pg_slave1` - Slave 1 PostgreSQL datadir
- `pg_slave2` - Slave 2 PostgreSQL datadir

If you restart/delete cluster containers all data will be available as before, in case you want to wipe all data in persistent volumes you must delete all volumes.

Wipe all volumes (works when containers stack is down)

**Pay attention: it removes all not used volumes, if you have volumes from other projects do not use it**
```
docker volume prune
```

Instead using bulk volumes removal command, you may use this command to remove a single volume:
```
docker volume rm <volume-name>
```s

## Manage Databases with ClusterControl

Open to ClusterControl Dashboard through the web address: http://server-ip-or-hostname:5000/clustercontrol  
Now you can configure a new cluster and import PostgreSQL nodes.

In order to configure your cluster please follow official guide on Severalnines website: https://severalnines.com/

--------------------------------
MIT License


