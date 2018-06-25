#!/bin/sh
i=1

while [ $i=1 ]
do
echo " [`date`] START LOW proirity copy" >> /var/log/cpuprior.log
cp -f /etc/httpd/conf/httpd.conf /home/vagrant
echo " [`date`] STOP LOW priority copy" >> /var/log/cpuprior.log
done
