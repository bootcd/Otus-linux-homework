## Домашнее задание
#### VPN
#### 1. Между двумя виртуалками поднять vpn в режимах
- tun
- tap
Прочуствовать разницу.

#### 2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку

1.Поднимаем 2 виртуалки и [сервер](https://github.com/bootcd/Otus-linux-homework/blob/VPN/1/server.conf) OpenVPN на одной из них, на другой [клиент](https://github.com/bootcd/Otus-linux-homework/blob/VPN/1/client.conf).

Тестируем в режиме tun:
```
iperf -c 192.168.50.6 -i 5 -t 30
------------------------------------------------------------
Client connecting to 192.168.50.6, TCP port 5001
TCP window size: 45.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.50.1 port 42210 connected with 192.168.50.6 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 5.0 sec  85.6 MBytes   144 Mbits/sec
[  3]  5.0-10.0 sec  76.2 MBytes   128 Mbits/sec
[  3] 10.0-15.0 sec  75.2 MBytes   126 Mbits/sec
[  3] 15.0-20.0 sec  84.2 MBytes   141 Mbits/sec
[  3] 20.0-25.0 sec  91.5 MBytes   154 Mbits/sec
[  3] 25.0-30.0 sec  81.2 MBytes   136 Mbits/sec
[  3]  0.0-30.0 sec   494 MBytes   138 Mbits/sec
```

Тестируем в режиме tap:

```
iperf -c 192.168.50.2 -i 5 -t 30
------------------------------------------------------------
Client connecting to 192.168.50.2, TCP port 5001
TCP window size: 45.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.50.1 port 36950 connected with 192.168.50.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 5.0 sec  91.6 MBytes   154 Mbits/sec
[  3]  5.0-10.0 sec  68.9 MBytes   116 Mbits/sec
[  3] 10.0-15.0 sec  57.1 MBytes  95.8 Mbits/sec
[  3] 15.0-20.0 sec  59.5 MBytes  99.8 Mbits/sec
[  3] 20.0-25.0 sec  70.4 MBytes   118 Mbits/sec
[  3] 25.0-30.0 sec  69.0 MBytes   116 Mbits/sec
[  3]  0.0-30.1 sec   416 MBytes   116 Mbits/sec
```

Видим, что в режиме tap все медленнее.
