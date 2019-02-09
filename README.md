# cassandra-docker-swarm
This repo contains code and test files to setup cassandra using docker swarm

## Example Call
Will create a custom image with the tag 0.1

```
ansible-playbook ./cassandra_build_image.yml -i localhost, --extra-vars='new_image_tag="0.1"'
```

Will create a custom image in a different repo and tag
```
ansible-playbook ./cassandra_build_image.yml -i localhost, --extra-vars='new_image_tag="0.2" image_repo="myrepo"'
```
