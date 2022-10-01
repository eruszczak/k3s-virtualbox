require 'yaml'

inventory = YAML.load_file(File.join(__dir__, 'inventory.yml'))

vm_box = "generic/ubuntu2204"
default_interface = "Intel(R) Wi-Fi 6 AX201 160MHz"
# default_interface = "Intel(R) Ethernet Connection (13) I219-LM"

Vagrant.configure("2") do |config|
  inventory['all']['children'].each do |group, properties|
    properties['hosts'].each do |host, host_vars|
      config.vm.define host do |node|
        node.vm.box = vm_box
        node.vm.network "public_network", bridge: default_interface, ip: host_vars['ansible_host']
        # node.vm.network "public_network", bridge: default_interface # IP assigned via DHCP
        node.vm.hostname = host
        # node.vm.disk :disk, size: disk_size, primary: true
        node.vm.provider "virtualbox" do |v|
          v.memory = host_vars['memory']
          v.cpus = host_vars['cpu']
          v.name = host
        end
      end
    end
  end

  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = :host
  end

  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"

  config.vm.provision "shell", inline: <<-SHELL
    cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
  SHELL
end
