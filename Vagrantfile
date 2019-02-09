# -*- mode: ruby -*-
# vi: set ft=ruby :

# install files for vagrant can be found here;
# https://www.vagrantup.com/downloads.html

domain   = 'docker'
boxtype = "centos/7"

# define your node spec below, use unique two digit number for id 
nodes = [
  { :hostname => 'master',  :ip => '10.0.0.10', :id => '10' , :cpu => 2 , :port => 6443, :netport => 8043, :memory => 2000},
  { :hostname => 'node1',   :ip => '10.0.0.11', :id => '11' , :cpu => 2 , :port => 6444, :netport => 8044, :memory => 2000},
  { :hostname => 'node2',   :ip => '10.0.0.12', :id => '12' , :cpu => 2 , :port => 6445, :netport => 8045, :memory => 2000},
  { :hostname => 'node3',   :ip => '10.0.0.13', :id => '13' , :cpu => 2 , :port => 6446, :netport => 8046, :memory => 2000}
]


Vagrant.configure("2") do |config|

    nodes.each do |node|

      config.vm.define node[:hostname] do |nodeconfig|

        nodeconfig.vm.box = boxtype
        nodeconfig.vm.hostname = node[:hostname]
        nodeconfig.vm.network :private_network, ip: node[:ip], virtualbox__intnet: domain
        nodeconfig.vm.network "forwarded_port", guest: 6443, host: node[:port]
        nodeconfig.vm.network "forwarded_port", guest: 8001, host: node[:netport]

        nodeconfig.vm.provider :virtualbox do |vb|

          vb.name = node[:hostname]+"."+domain
          vb.memory = node[:memory]
          vb.cpus = node[:cpu]
          vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
          vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
          vb.customize ['modifyvm', :id, '--macaddress1', "5CA1AB1E00"+node[:id]]
          vb.customize ['modifyvm', :id, '--natnet1', "192.168/16"]

        end

        # lets copy the host files to each node
        nodeconfig.vm.provision "file", source: "./setup/hosts", destination: "/etc/hosts"
        nodeconfig.vm.provision "file", source: "~/.vagrant.d/insecure_private_key", destination: "/home/vagrant/.ssh/id_rsa"

        # lets install docker on each of the nodes
        nodeconfig.vm.provision "docker"
        nodeconfig.vm.provision "shell", path: "./setup/bootstrap.sh"

      end

    end

    #config.vm.provision "shell", path: "./setup/bootstrap.sh"

  # config.vm.provision "ansible_local" do |ansible|
  #   ansible.verbose = "v"
  #   ansible.playbook = "./setup/ansible/playbooks/configure_env.yml"
  # end

end
