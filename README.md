## Домашнее задание

Vagrant стенд  для NFS или.SAMBA
NFS или SAMBA на выбор
vagrant up должен поднимать 2 виртуалки: сервер и клиент
на сервер должна быть расшарена директория
на клиента она должна автоматически монтироваться при старте ( fstab или autofs)
в шаре должна быть папка upload с правами на запись
- требования дл NFS: NFSv3 по UDP, включенный firewall

## NFS
Для проверки задания необходимо поднять инфраструктуру с помощью [Vagrantfile](https://github.com/bootcd/Otus-linux-homework/blob/nfs/Vagrantfile), зайти на машину nfsClient и выполнить команду `mount`, убедиться, что nfs шара присутсвует в списке примонтированых объектов:
```
192.168.255.1:/share on /mnt/shared type nfs
```
Каталог `/mnt/shared/upload` доступен на запись.

На машине nfsServer выполнить команду `netstat -nau`, чтобы убедиться, что nfs в этот момент работает на UDP


#### Выполнение

1.Создаем каталог для шары `/share` и прописываем его в эскпорт

`vi /etc/exports`
```
/share 192.168.255.1/26(rw,async,no_subtree_check,no_root_squash)
```
в файл `/etc/hosts.allow` добавляем разрешение на подключение с клиента:
```
portmap: 192.168.255.2 255.255.255.192
lockd: 192.168.255.2 255.255.255.192
mountd: 192.168.255.2 255.255.255.192
rquotad: 192.168.255.2 255.255.255.192
statd: 192.168.255.2 255.255.255.192
```
В файле `/etc/nfs.conf` прописываем конфиг, который нам нужен.
Указываем, что мы хотим работать по `UDP`, слушать на порту `2049` и использовать только `nfs3`
```
[nfsd]
host=192.168.255.1
port=2049
udp=y
tcp=n
vers3=y
vers4=n
vers4.0=n
vers4.1=n
vers4.2=n

```

Перечитаем конфигурацию:
`exportfs -r`

2. Включаем `firewalld`

`service firewalld start`

Добавялем правила для нужных нам портов:

```
firewall-cmd --permanent --zone=public --add-port=111/udp
firewall-cmd --permanent --zone=public --add-port=2049/udp
firewall-cmd --permanent --zone=public --add-port=20048/udp
firewall-cmd --reload

```
Запустим сервер NFS командой `service nfs start`

Смотрим вывод команды `netstat -nau`, получаем такой вывод:
```
udp        0      0 192.168.255.1:2049      0.0.0.0:*
udp        0      0 0.0.0.0:33058           0.0.0.0:*
udp        0      0 127.0.0.1:323           0.0.0.0:*
udp        0      0 0.0.0.0:68              0.0.0.0:*
udp        0      0 0.0.0.0:20048           0.0.0.0:*
udp        0      0 0.0.0.0:111             0.0.0.0:*
udp        0      0 0.0.0.0:655             0.0.0.0:*
udp        0      0 127.0.0.1:659           0.0.0.0:*
udp        0      0 0.0.0.0:37075           0.0.0.0:*

```
Видим, что служба поднялась.

3. На клиенте создаим каталог `/mnt/shared`

и добавим в `/etc/fstab` строчку

`192.168.255.1:/share /mnt/shared nfs  proto=udp,intr,noatime,nolock,nfsvers=3,async 0 0`

после выполнения команды `mount -a`, видим, что шара примонтировалась:

`192.168.255.1:/share on /mnt/shared type nfs`
