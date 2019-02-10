#!bin/bash

## custom entry point script for official cassandra docker image
## The seeding doesn't appear to work when using the with swarm 
## this will query the hosts and looking for tasks.cassandra and 
## add those to the seed list

## lets bomb out if we hit any errors
set -e

## lets look for other tasks

cassandra_ip=$(hostname --ip-address)
cassandra_tasks=$(getent hosts tasks.cassandra | awk '{print $1}' ORS=',\n' | sed "/$cassandra_ip/d" )

# TODO: add automatic rack placement based on node counts
#export CASSANDRA_SEEDS="auto"

if [ ! -z "$cassandra_tasks" ]
then
    export CASSANDRA_SEEDS=$(echo $cassandra_tasks | sed s'/,$//')
fi

#export CASSANDRA_LISTEN_ADDRESS=$cassandra_ip
#export CASSANDRA_BROADCAST_ADDRESS=$cassandra_ip

# call the official docker entrypoint
/docker-entrypoint.sh cassandra -f