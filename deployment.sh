#!/bin/sh
yum -y install httpd
touch /var/log/cpuprior.log
sudo mkdir /concurents
cd /vagrant
cp cpuconcurent.target hiprior.service lowprior.service /etc/systemd/system
cp hicpuprior.sh lowcpuprior.sh /concurents
sudo service cpuconcurent.target start