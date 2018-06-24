#!/bin/sh

i=1

while [ $i=1 ]
do
grep -e $WORD -F $FILE >> /home/vagrant/greplog
sleep 30
done

