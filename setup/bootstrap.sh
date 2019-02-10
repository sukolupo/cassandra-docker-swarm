#!/bin/bash

yum update

# lets enable EPEL  additional package repository
yum install -y epel-release

## install some additional dependencies
yum install -y yum-utils device-mapper-persistent-data lvm2 ansible python-pip git

# lets upgrade pip
pip install --upgrade pip

# lets install scqlsh on each of the nodes 
pip install cqlsh

# ansible docker modules for python 2.7
pip install docker

# lets disable swap
swapoff -a

## set up out git repo and refresh if require
mkdir /home/vagrant/git
cd /home/vagrant/git 

if [ ! -d "/home/vagrant/git/cassandra-docker-swarm" ]
then
    git clone https://github.com/sukolupo/cassandra-docker-swarm.git
else
    cd /home/vagrant/git/cassandra-docker-swarm 
    git pull 
fi

chown -R vagrant:vagrant /home/vagrant/git

cat /home/vagrant/hosts > /etc/hosts

chmod 600 /home/vagrant/.ssh/id_rsa
#cat /home/vagrant/.ssh/id_rsa_vagrant.pub >> /home/vagrant/.ssh/authorized_keys
#modprobe br_netfilter
#echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
