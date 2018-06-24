#!/bin/sh
sudo yum install -y httpd
sudo yum install -y epel-release
sudo yum install -y spawn-fcgi php php-cli mod_fcgid httpd

cd /vagrant

cp grepper.service /etc/systemd/system
cp httpd@.service spawn-fsgi.service httpd.target /usr/lib/systemd/system
cp grepper.sh /usr/bin
cp httpd-conf2 httpd-conf3 grepper.conf /etc/sysconfig
cp httpd-conf2.conf httpd-conf3.conf /etc/httpd/conf

sudo service grepper start
sudo service httpd.target start
sudo service spawn-fsgi start
