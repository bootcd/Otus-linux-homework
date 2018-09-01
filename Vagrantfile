# -*- mode: ruby -*-
# vim: set ft=ruby :
# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
:nfsServer => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.1', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "nfs-net"},
                ]
  },
  
 

  :nfsClient => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.2', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "nfs-net"},
                   
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
        when "nfsServer"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
			mkdir /share/
			mkdir /share/upload
			cd /share
			chmod 777 upload
			cd /vagrant/
			cp -f hosts.allow exports nfs.conf /etc/
			service nfs restart
			service rpcbind restart
			exportfs -r
			service firewalld start
			firewall-cmd --permanent --zone=public --add-port=111/udp
			firewall-cmd --permanent --zone=public --add-port=2049/udp
			firewall-cmd --permanent --zone=public --add-port=20048/udp
			firewall-cmd --reload
            SHELL
			
		when "nfsClient"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
			mkdir /mnt/shared
			echo "192.168.255.1:/share /mnt/shared nfs  proto=udp,intr,noatime,nolock,nfsvers=3,async 0 0" >> /etc/fstab
			mount -a
			SHELL
			
			end

      end

  end
  
  
end

