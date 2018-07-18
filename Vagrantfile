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
				   {adapter: 3, auto_config: false, virtualbox__intnet: true},
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
				   {adapter: 8, auto_config: false, virtualbox__intnet: true},
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
	:office1Server => {
		:box_name => "centos/7",
		:net => [
					{ip: '192.168.2.2', adapter: 2, netmask: "255.255.255.128", virtualbox__intnet: "dev1-net"},
				]
},

	:testServer1 => {
		:box_name => "centos/7",
		:net => [
					{ip: '192.168.2.66', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "dev1-net"},
				]
},

	:testServer2 => {
		:box_name => "centos/7",
		:net => [
					{ip: '192.168.2.67', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "dev1-net"},
				]
},
	:testClient1 => {
		:box_name => "centos/7",
		:net => [
					{ip: '192.168.2.68', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "dev1-net"},
				]
},
	:testClient2 => {
		:box_name => "centos/7",
		:net => [
					{ip: '192.168.2.69', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "dev1-net"},
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
			ip route add 192.168.2.0/25 via 192.168.255.2
			ip route add 192.168.1.0/25 via 192.168.255.2
			echo "BOOTPROTO=static\nONBOOT=yes\nTYPE=Bond\nBONDING_MASTER=yes\nIPADDR=192.168.255.1\nPREFIX=30\nDEVICE="bond0"\nBONDING_OPTS="mode=1 miimon=100"" > /etc/sysconfig/network-scripts/ifcfg-bond0
			echo "BOOTPROTO=none\nONBOOT=yes\nDEVICE=eth1\nMASTER=bond0\nSLAVE=yes" > /etc/sysconfig/network-scripts/ifcfg-eth1
			echo "BOOTPROTO=none\nONBOOT=yes\nDEVICE=eth1\nMASTER=bond0\nSLAVE=yes" > /etc/sysconfig/network-scripts/ifcfg-eth2
			service network restart
			sysctl net.ipv4.conf.all.forwarding=1
			iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o eth0 -j MASQUERADE
			sudo iptables -t nat -A POSTROUTING -s 192.168.255.0/30 -j MASQUERADE
            SHELL
        when "centralRouter"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
            echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
            systemctl restart network
            ip route add 192.168.2.0/24 via 192.168.240.2
            ip route add 192.168.1.0/24 via 192.168.230.2
			echo "BOOTPROTO=static\nONBOOT=yes\nTYPE=Bond\nBONDING_MASTER=yes\nIPADDR=192.168.255.2\nPREFIX=30\nDEVICE="bond0"\nBONDING_OPTS="mode=1 miimon=100"" > /etc/sysconfig/network-scripts/ifcfg-bond0
			echo "BOOTPROTO=none\nONBOOT=yes\nDEVICE=eth1\nMASTER=bond0\nSLAVE=yes" > /etc/sysconfig/network-scripts/ifcfg-eth1
			echo "BOOTPROTO=none\nONBOOT=yes\nDEVICE=eth1\nMASTER=bond0\nSLAVE=yes" > /etc/sysconfig/network-scripts/ifcfg-eth6
			echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-bond0
			service network restart
			sysctl net.ipv4.conf.all.forwarding=1
            SHELL
		when "office1Router"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
            echo "GATEWAY=192.168.240.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
            systemctl restart network
			sudo sysctl net.ipv4.conf.all.forwarding=1
            SHELL
		when "office1Server"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
            echo "GATEWAY=192.168.2.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
            sudo systemctl restart network
            SHELL
		when "testServer1"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "GATEWAY=192.168.2.65" >> /etc/sysconfig/network-scripts/ifcfg-eth1
			echo "NM_CONTROLLED=no\nBOOTPROTO=static\nONBOOT=yes\nVLAN=yes\nIPADDR=10.10.10.1\nNETMASK=255.255.255.0\nDEVICE=eth1.10" > /etc/sysconfig/network-scripts/ifcfg-eth1.10
            sudo systemctl restart network
            SHELL
		when "testServer2"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "GATEWAY=192.168.2.65" >> /etc/sysconfig/network-scripts/ifcfg-eth1
			echo "NM_CONTROLLED=no\nBOOTPROTO=static\nONBOOT=yes\nVLAN=yes\nIPADDR=10.10.10.1\nNETMASK=255.255.255.0\nDEVICE=eth1.20" > /etc/sysconfig/network-scripts/ifcfg-eth1.20
            sudo systemctl restart network
            SHELL
		when "testClient1"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "GATEWAY=192.168.2.65" >> /etc/sysconfig/network-scripts/ifcfg-eth1
			echo "NM_CONTROLLED=no\nBOOTPROTO=static\nONBOOT=yes\nVLAN=yes\nIPADDR=10.10.10.254\nNETMASK=255.255.255.0\nDEVICE=eth1.10" > /etc/sysconfig/network-scripts/ifcfg-eth1.10
            sudo systemctl restart network
            SHELL
		when "testClient2"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "GATEWAY=192.168.2.65" >> /etc/sysconfig/network-scripts/ifcfg-eth1
			echo "NM_CONTROLLED=no\nBOOTPROTO=static\nONBOOT=yes\nVLAN=yes\nIPADDR=10.10.10.254\nNETMASK=255.255.255.0\nDEVICE=eth1.20" > /etc/sysconfig/network-scripts/ifcfg-eth1.20
            sudo systemctl restart network
            SHELL
        end

      end

  end
  
  
end

