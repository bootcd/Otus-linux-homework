# -*- mode: ruby -*-
# vim: set ft=ruby :
# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
:ansibleServer => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.1', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "post-net"},
                ]
  },
  
 

  :postgresServer => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.2', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "post-net"},
                   
                ]
  },
  
    :postgresReplic => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.3', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "post-net"},
                   
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
        when "ansibleServer"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
		
            SHELL
			
		when "postgresServer"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
			sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
			service sshd restart
			SHELL
			
			
		when "postgresReplic"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
			sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
			service sshd restart
			SHELL
			
			end

      end

  end
  
  
end

