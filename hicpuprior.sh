#!/bin/sh
i=1

while [ $i=1 ]
do
echo " [`date`] START HI priority copy" >> var/log/cpuprior.log
 cp -f /etc/httpd/conf/httpd.conf /root
echo " [`date`] STOP HI priority copy" >> /var/log/cpuprior.log
done
