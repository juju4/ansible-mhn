# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "ubuntu/trusty64"

    # Configuration for Ansible as Provisioner
    config.vm.provision :ansible do |ansible|
       ansible.playbook = "site.yml"
       #ansible.verbose = "v"
       #ansible.host_key_checking = false
       #ansible.limit = 'all'
       ansible.sudo = true
       ansible.extra_vars = { ansible_ssh_user: 'vagrant' }
       ansible.groups = {
          "mhnclient" => ["node1", "node2" ],
          "mhnserver" => ["mhn"],
       }
    end

    config.vm.define "mhntop" do |mhntop|
        mhntop.vm.hostname = "mhntop"
        mhntop.vm.provider "virtualbox" do |v|
          v.memory = 1024
        end
        mhntop.vm.network "private_network", ip: "192.168.200.53"
        mhntop.vm.network "forwarded_port", guest: 80, host: 8880
        mhntop.vm.network "forwarded_port", guest: 443, host: 8443
    end

    (1..2).each do |i|
        config.vm.define "node#{i}" do |node|
            node.vm.box = "ubuntu/trusty64"
            node.vm.provider "virtualbox" do |v|
              v.memory = 512
            end
            node.vm.hostname = "node#{i}"
            node.vm.network :private_network, ip: "192.168.200.6#{i}"
            ## if using kippo, update here
            #node.ssh.port = 2222
        end
    end

end

