# vi: set ft=ruby :

# Builds Puppet Master and multiple Puppet Agent Nodes using JSON config file
# Author: Gary A. Stafford
# Contributor: Sod Oscarfono

# read vm configurations from JSON files
nodes_config = (JSON.parse(File.read("provisioning/nodes.json")))['nodes']

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.synced_folder "provisioning", "/vagrant/provisioning", type:"rsync"


  nodes_config.each do |node|

    node_name   = node[0] # name of node
    node_values = node[1] # content of node

    config.vm.define node_name do |config|    
      # configures all forwarding ports in JSON array
      ports = node_values['ports']
      ports.each do |port|
        config.vm.network :forwarded_port,
                          host:  port[':host'],
                          guest: port[':guest'],
                          id:    port[':id']
      end

      config.vm.hostname = node_name
      config.vm.network :private_network, ip: node_values[':ip']

      config.vm.provider :libvirt do |domain|
        domain.cpus = node_values[':cpus']
        domain.memory = node_values[':memory']
        domain.nested = node_values[':nested']
      end

      config.vm.provision :shell, :path => node_values[':bootstrap']

      config.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file = "site.pp"
        puppet.module_path = "puppet/modules"
      end

    end
  end
end
