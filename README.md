# cassandra-docker-swarm
This repo contains code and test files to setup cassandra using docker swarm

## Building your own Custom image
Use the playbook calls below to build the docker image (if required).

A prebuilt docker image can be found here https://hub.docker.com/r/sukolupo/cassandra

Don't forget to call "docker login" before running the playbook, otherwise it will fail on upload.

### Example Call
Will create a custom image with the tag 0.1

```
ansible-playbook ./cassandra_build_image.yml -i localhost, --extra-vars='new_image_tag="0.1"'
```

Will create a custom image in a different repo and tag
```
ansible-playbook ./cassandra_build_image.yml -i localhost, --extra-vars='new_image_tag="0.2" image_repo="myrepo"'
```


## Testing using Vagrant
The repo contains all the configuration files to test. The images are based on CentOS7

run the following to spin up the four node environment
```
vagrant up
```

As part of the setup it should also pull from this repo, so all the code is ready to go.
```
cd ~/git/cassandra-docker-swarm
```

### The Nodes
* Master - Standalone node outside of the swarm. I use this to test external connectivity using cqlsh

* Node1 - The Leader node.

* Node2 - Worker node.

* Node3 - Worker node.

SSH is configured so you shoud be able to connect between each of the nodes without using passwords.

## Setting up the Swarm
I have created a playbook to setup and configure the docker swarm, you can provide your own inventory files to setup a swarm on any machines you like. 

I have provided a inventory file to work with the test vagrant environment.

### Example Call
Will create a 3 node docker swarm.
```
ansible-playbook ./docker_create_swarm.yml -i ./hosts/vagrant_hosts
```


## Deploying the Stack
To deploy the cassandra stack run the following;

```
docker stack deploy -c /vagrant/docker-compose-cassandra.yaml <cluster name>
```

This will create one cassandra node.

Once the node is up and running

```
docker exec -it <container> bash -c 'nodetool status'
```

You can scale the cluster by running the following;

```
docker service scale <cluster name>_cassandra=2
```

### Test Connectivity from Outside of the Swarm

Determine the port mapped to 9042.

```
docker stack services <cluster name>
```

The output should show the mapping.

Now run the following to connect;

```
cqlsh node1 <exposed port> --cqlversion="3.4.4"
```
