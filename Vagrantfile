require 'yaml'

inventory = YAML.load_file(File.join(__dir__, 'inventory.yml'))

vm_box = "generic/ubuntu2204"
default_interface = "Intel(R) Wi-Fi 6 AX201 160MHz"

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

  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"

  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = :host
  end

  config.vm.provision "shell", inline: <<-SHELL
    cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
  SHELL

  # config.vm.provision "ansible" do |ansible|
    # ansible.playbook = "playbook.yml"
  # end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.0.0"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"
end
