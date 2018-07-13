# -*- mode: ruby -*-
# vim: set ft=ruby :
# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
:inetRouter => {
        :box_name => "centos/6",
        #:public => {:ip => '10.10.10.1', :adapter => 1},
        :net => [
                   {ip: '192.168.255.1', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "router-net"},
                ]
  },
  :centralRouter => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.2', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "router-net"},
                   {ip: '192.168.0.1', adapter: 3, netmask: "255.255.255.240", virtualbox__intnet: "dir-net"},
                   {ip: '192.168.0.33', adapter: 4, netmask: "255.255.255.240", virtualbox__intnet: "hw-net"},
                   {ip: '192.168.0.65', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "mgt-net"},
				   {ip: '192.168.240.1', adapter: 6, netmask: "255.255.255.252", virtualbox__intnet: "of1router-net"},
				   {ip: '192.168.230.1', adapter: 7, netmask: "255.255.255.252", virtualbox__intnet: "of2router-net"},
                ]
  },
  
  :centralServer => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.0.2', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "dir-net"},
                ]
  },
  
  :office1Router => {
		:box_name => "centos/7",
		:net => [
					{ip: '192.168.240.2', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "of1router-net"},
					{ip: '192.168.2.1', adapter: 3, netmask: "255.255.255.128", virtualbox__intnet: "dev1-net"},
					{ip: '192.168.2.65', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "tstsrv1-net"},
					{ip: '192.168.2.129', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "mngmt1-net"},
					{ip: '192.168.2.192', adapter: 6, netmask: "255.255.255.192", virtualbox__intnet: "ofhw1-net"},
				]
},

  :office2Router => {
		:box_name => "centos/7",
		:net => [
					{ip: '192.168.230.2', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "of2router-net"},
					{ip: '192.168.1.1', adapter: 3, netmask: "255.255.255.128", virtualbox__intnet: "dev2-net"},
					{ip: '192.168.1.129', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "tstsrv2-net"},
					{ip: '192.168.1.192', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "ofhw2-net"},
				]
},
  :office2Server => {
		:box_name => "centos/7",
		:net => [
					{ip: '192.168.1.2', adapter: 2, netmask: "255.255.255.128", virtualbox__intnet: "dev2-net"},
				]
},
	:office1Server => {
		:box_name => "centos/7",
		:net => [
					{ip: '192.168.2.2', adapter: 2, netmask: "255.255.255.128", virtualbox__intnet: "dev1-net"},
				]
},

}
Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname do |box|

        box.vm.box = boxconfig[:box_name]
        box.vm.host_name = boxname.to_s

        boxconfig[:net].each do |ipconf|
          box.vm.network "private_network", ipconf
        end
        
        if boxconfig.key?(:public)
          box.vm.network "public_network", boxconfig[:public]
        end

        box.vm.provision "shell", inline: <<-SHELL
          mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
        SHELL
        
        case boxname.to_s
        when "inetRouter"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            sysctl net.ipv4.conf.all.forwarding=1
            iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o eth0 -j MASQUERADE
			sudo iptables -t nat -A POSTROUTING -s 192.168.255.0/30 -j MASQUERADE
			ip route add 192.168.2.0/25 via 192.168.255.2
			ip route add 192.168.1.0/25 via 192.168.255.2
            SHELL
        when "centralRouter"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
            echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
            systemctl restart network
			sysctl net.ipv4.conf.all.forwarding=1
            ip route add 192.168.2.0/24 via 192.168.240.2
            ip route add 192.168.1.0/24 via 192.168.230.2
            SHELL
        when "centralServer"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
            echo "GATEWAY=192.168.0.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
            systemctl restart network
            SHELL
		when "office1Router"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
            echo "GATEWAY=192.168.240.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
            systemctl restart network
			sudo sysctl net.ipv4.conf.all.forwarding=1
            SHELL
		when "office2Router"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
			echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
            echo "GATEWAY=192.168.230.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
            sudo systemctl restart network
			sudo sysctl net.ipv4.conf.all.forwarding=1
			SHELL
		when "office1Server"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
            echo "GATEWAY=192.168.2.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
            sudo systemctl restart network
            SHELL
		when "office2Server"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
            echo "GATEWAY=192.168.1.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
            systemctl restart network
            SHELL
        end

      end

  end
  
  
end

