#!bin/bash

## custom entry point script for official cassandra docker image
## The seeding doesn't appear to work when using the with swarm 
## this will query the hosts and looking for tasks.cassandra and 
## add those to the seed list

## lets bomb out if we hit any errors
set -e

## lets look for other tasks
cassandra_tasks="$(getent hosts task.cassandra | awk '{print $1}' ORS=', ' | sed s'/..$//')"
cassandra_ip="$(hostname --all-ip-address | awk '{print $1}' ORS=', ' | sed s'/..$//')"

# TODO: add automatic rack placement based on node counts

if [ ! -z "$cassandra_tasks"]
then
    export CASSANDRA_SEEDS=cassandra_tasks
fi


# call the official docker entrypoint
/docker-entrypoint.sh cassandra -f