
## Домашнее задание
#### OSPF
- Поднять три виртуалки
- Объединить их разными vlan
1. Поднять OSPF между машинами на базе Quagga
2. Изобразить ассиметричный роутинг
3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным

#### Присылаем 
- вывод ip a
- конфиги /etc/quagga/*
- вывод tracepath для каждого из трёх случаев

#### - Поднять три виртуалки
 Используем подготовленный [VagrantFile](https://github.com/bootcd/Otus-linux-homework/blob/OSPF/1/Vagrantfile), поднимаем Router1, Router2 и Router3 с ВЛАНАМИ как на рисунке.
![](https://github.com/bootcd/Otus-linux-homework/blob/OSPF/%D1%81%D1%85%D0%B5%D0%BC%D0%B01.jpg)
 
 #### Поднять OSPF между машинами на базе Quagga
 В каталоге /etc/quagga/ на каждой машине редактируем файлы zebra.conf и ospfd.conf
 
 #### Router1

 <details>
 <summary>ip a</summary>
 
 ```
 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c9:c7:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 78868sec preferred_lft 78868sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:b8:9f:24 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:d8:5a:9b brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:87:c5:65 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.10/26 brd 192.168.1.63 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe87:c565/64 scope link
       valid_lft forever preferred_lft forever
6: eth1.10@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:b8:9f:24 brd ff:ff:ff:ff:ff:ff
    inet 192.168.10.1/24 brd 192.168.10.255 scope global eth1.10
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feb8:9f24/64 scope link
       valid_lft forever preferred_lft forever
7: eth2.20@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:d8:5a:9b brd ff:ff:ff:ff:ff:ff
    inet 192.168.20.1/24 brd 192.168.20.255 scope global eth2.20
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fed8:5a9b/64 scope link
       valid_lft forever preferred_lft forever
 
 ```
 
 </details>
 
 <details>
 <summary> zebra.conf</summary>


 ```
 
 ! -*- zebra -*-

hostname Router1
password zebra
enable password zebra

interface lo
description loopback
ip address 127.0.0.1/8
ip forwarding

interface eth1.10
description toRouter2
ip address 192.168.10.1/24
ip forwarding

interface eth2.20
description toRouter3
ip address 192.168.20.1/24
ip forwarding

interface eth3
description LAN
ip address 192.168.1.10/26
ip forwarding

```
</details>

<details>
<summary>ospfd.conf</summary>
 
```

! -*- ospf -*-
hostname Router1
password zebra

router ospf
router-id 0.0.0.1
network 192.168.1.0/26 area 1
network 192.168.10.0/24 area 0
network 192.168.20.0/24 area 0
neighbor 192.168.10.2
neighbor 192.168.20.2
!
log stdout
 
 ```
 </details>
 
 #### Router2
 
 <details>
 <summary>ip a</summary>
 
 ```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c9:c7:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 78893sec preferred_lft 78893sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:43:54:c1 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:fb:ba:0a brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:a8:c0:5c brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.10/26 brd 192.168.2.63 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fea8:c05c/64 scope link
       valid_lft forever preferred_lft forever
6: eth1.10@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:43:54:c1 brd ff:ff:ff:ff:ff:ff
    inet 192.168.10.2/24 brd 192.168.10.255 scope global eth1.10
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe43:54c1/64 scope link
       valid_lft forever preferred_lft forever
7: eth2.30@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:fb:ba:0a brd ff:ff:ff:ff:ff:ff
    inet 192.168.30.1/24 brd 192.168.30.255 scope global eth2.30
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fefb:ba0a/64 scope link
       valid_lft forever preferred_lft forever 
 
 ```
 
 </details>
 
  <details>
 <summary>zebra.conf</summary>
 
  ```
 
! -*- zebra -*-
!
! zebra sample configuration file
!
! $Id: zebra.conf.sample,v 1.1 2002/12/13 20:15:30 paul Exp $
!
hostname Router2
password zebra
enable password zebra
!
! Interface's description.
!
interface lo
description loopback
ip address 127.0.0.1/8
ip forwarding

interface eth1.10
description toRouter1
ip address 192.168.10.2/24
ip forwarding

interface eth2.30
description toRouter3
ip address 192.168.30.1/24
ip forwarding

interface eth3
description LAN
ip address 192.168.2.10/26
ip forwarding
 
 ```
 
 </details>
 
 <details>
 <summary>ospfd.conf</summary>

 ```
 
 ! -*- ospf -*-

hostname Router2
password zebra

router ospf
router-id 0.0.0.2
network 192.168.2.0/26 area 2
network 192.168.10.0/24 area 0
network 192.168.30.0/24 area 0
neighbor 192.168.10.1
neighbor 192.168.30.2
!
log stdout
 
 ```
 </details>
 
 #### Router3
 <details>
 <summary>ip a</summary>
 
  ```
 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c9:c7:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 78911sec preferred_lft 78911sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:bf:4d:e7 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:c8:b4:58 brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:be:ef:bc brd ff:ff:ff:ff:ff:ff
    inet 192.168.3.10/26 brd 192.168.3.63 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:febe:efbc/64 scope link
       valid_lft forever preferred_lft forever
6: eth1.30@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:bf:4d:e7 brd ff:ff:ff:ff:ff:ff
    inet 192.168.30.2/24 brd 192.168.30.255 scope global eth1.30
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:febf:4de7/64 scope link
       valid_lft forever preferred_lft forever
7: eth2.20@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:c8:b4:58 brd ff:ff:ff:ff:ff:ff
    inet 192.168.20.2/24 brd 192.168.20.255 scope global eth2.20
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fec8:b458/64 scope link
       valid_lft forever preferred_lft forever
       
 ```
</details> 

<details>
 <summary>zebra.conf</summary>

 ```
 ! -*- zebra -*-
!
! zebra sample configuration file
!
! $Id: zebra.conf.sample,v 1.1 2002/12/13 20:15:30 paul Exp $
!
hostname Router3
password zebra
enable password zebra
!
! Interface's description.
!
interface lo
description loopback
ip address 127.0.0.1/8
ip forwarding

interface eth1.20
description toRouter1
ip address 192.168.20.2/24
ip forwarding

interface eth2.30
description toRouter2
ip address 192.168.30.2/24
ip forwarding

interface eth3
description LAN
ip address 192.168.3.10/26
ip forwarding

```
</details>

<details>
<summary>ospf.conf</summary>

```
 ! -*- ospf -*-

hostname Router3
password zebra

router ospf
router-id 0.0.0.3
network 192.168.3.0/26 area 3
network 192.168.20.0/24 area 0
network 192.168.30.0/24 area 0
neighbor 192.168.20.1
neighbor 192.168.30.1
!
log stdout
 
 ```
</details> 

 Для проверки работы роутинга поднимем еще по 1 ВМ за каждым из роутеров в area1, area2, area3.
 
 Проверим работоспособность роутинга утилитой `tracepath`
 
 #### Router1 -> area3
 
 ```
 tracepath 192.168.3.25

1?: [LOCALHOST] pmtu 1500

1: 192.168.20.2     0.827ms

1: 192.168.20.2     1.457ms

2: 192.168.3.25     1.546ms reached

Resume: pmtu 1500   hops 2 back 2
 
 ```
 #### Router2 -> area1
 
 ```
 tracepath 192.168.1.25

1?: [LOCALHOST] pmtu 1500

1: 192.168.10.1       0.988ms

1: 192.168.10.1       0.992ms

2: 192.168.1.25       1.146ms reached

Resume: pmtu 1500     hops 2 back 2
 
 ```
 #### Router3 -> area2
 
 ```
 tracepath 192.168.2.25

1?: [LOCALHOST] pmtu 1500

1: 192.168.30.1       0.836ms

1: 192.168.30.1       0.502ms

2: 192.168.2.25       1.188ms reached

Resume: pmtu 1500     hops 2 back 2
 
 ```
 
 #### 2. Изобразить ассиметричный роутинг
 
 Для этого создадим "перекос" цены на одном из концов линка VLAN30 на Router2 интерфейсе eth2.30, установив цену в 1000. На остальных роутерах на всех интерфейсах установим цену 10.

Добавим в ospfd.conf строки, определяющие "цену" для обоих интерфейсов как на рисунке:![](https://github.com/bootcd/Otus-linux-homework/blob/OSPF/2/%D1%81%D1%85%D0%B5%D0%BC%D0%B02.jpg)

 ```
interface eth2.30
ip ospf cost 1000

interface eth1.10
ip ospf cost 10
``` 
 
 
 Посмотрим что получилось в итоге:
 
 Router2 -> area3:
 ```
  tracepath 192.168.3.25
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.10.1                                          1.408ms
 1:  192.168.10.1                                          1.598ms
 2:  192.168.20.2                                          1.116ms
 3:  192.168.3.25                                          0.902ms reached
     Resume: pmtu 1500 hops 3 back 3
  ```
  Видим, что система использует более дешевый маршрут через Router1.
  
  Попробуем в обратную сторону:
  
  Router3 -> area2
  ````
  tracepath 192.168.2.25
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.30.1                                          1.035ms
 1:  192.168.30.1                                          0.741ms
 2:  192.168.2.25                                          1.325ms reached
  ````
  Видим что общение происходит напрямую.
  
  #### 3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным
  
  Для этого уравновесим стоимость линка VLAN30 до 1000 как на рисунке: ![](https://github.com/bootcd/Otus-linux-homework/blob/OSPF/3/%D1%81%D1%85%D0%B5%D0%BC%D0%B03.jpg)
  
  В ospfd.conf на Router3 изменим цену:
  
```
interface eth2.30
ip ospf cost 1000
```
Смотрим, что получилось:
Router2 -> area3
```
 tracepath 192.168.3.25
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.10.1                                          1.542ms
 1:  192.168.10.1                                          1.726ms
 2:  192.168.20.2                                          1.129ms
 3:  192.168.3.25                                          1.210ms reached
```
Трафик все также выбирает дешевый маршрут через VLAN10

И в обратную сторону:
Router3 -> area2

```
tracepath 192.168.2.25
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.20.1                                          1.529ms
 1:  192.168.20.1                                          1.646ms
 2:  192.168.10.2                                          1.118ms
 3:  192.168.2.25                                          1.314ms reached
```
Видим, что трафик ходит все так же более дешевым линком через LAN20 через Router1
