
#### Домашнее задание
Сценарии iptables
1) реализовать knocking port
- centralRouter может попасть на ssh inetrRouter через knock скрипт
пример в материалах
2) добавить inetRouter2, который виден(маршрутизируется) с хоста
3) запустить nginx на centralServer
4) пробросить 80й порт на inetRouter2 8080
5) дефолт в инет оставить через inetRouter

#### 1)реализовать knocking port

Можно

Реализуем конфигурацию из примера в материалах к занятию.

Создаем на inetRouter файл knocking_port.rules следующего содержания:

```
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
:TRAFFIC - [0:0]
:SSH-INPUT - [0:0]
:SSH-INPUTTWO - [0:0]
# TRAFFIC chain for Port Knocking. The correct port sequence in this example is  8881 -> 7777 -> 9991; any other sequence will drop the traffic 
-A INPUT -j TRAFFIC
-A TRAFFIC -p icmp --icmp-type any -j ACCEPT
-A TRAFFIC -m state --state ESTABLISHED,RELATED -j ACCEPT
-A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 22 -m recent --rcheck --seconds 30 --name SSH2 -j ACCEPT
-A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH2 --remove -j DROP
-A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 9991 -m recent --rcheck --name SSH1 -j SSH-INPUTTWO
-A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH1 --remove -j DROP
-A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 7777 -m recent --rcheck --name SSH0 -j SSH-INPUT
-A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH0 --remove -j DROP
-A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 8881 -m recent --name SSH0 --set -j DROP
-A SSH-INPUT -m recent --name SSH1 --set -j DROP
-A SSH-INPUTTWO -m recent --name SSH2 --set -j DROP 
-A TRAFFIC -j DROP
COMMIT

```

На centralRouter создаем кнок-скрипт knock.sh:

```
#!/bin/bash
HOST=$1
shift
for ARG in "$@"
do
        nmap -Pn --host_timeout 100 --max-retries 0 -p $ARG $HOST
done

```

На centralRouter запускаем скрипт `./knock.sh host 8881 7777 9991`
Теперь можем попробовать зайти на inetRouter через команду ssh 192.168.2551 -l vagrant 


#### 2-5)

Для проверки задания необходимо развернуть инфраструктуру на основе этого [Vagrantfile](https://github.com/bootcd/Otus-linux-homework/blob/Filtering/2-5/Vagrantfile) и перейти с хостовой машины по адресу http://127.0.0.1:8080

#### Ход выполнения:

2) добавить inetRouter2, который виден(маршрутизируется) с хоста

Добавляем еще оду виртуальную машину с 2 интерфейсами NAT и inner-net c ip адресом 192.168.255.10/26 в подсети Router1
На уровне Vagrant прописываем прокидку порта 8080 с localhost хостовой машины на WAN интерфейс inetRouter2
`box.vm.network "forwarded_port", guest: 8080, host: 8080`

3) запустить nginx на centralServer

yum -y install epel-release
yum -y install nginx
service nginx start


4) пробросить 80й порт на inetRouter2 8080

Прописываем роутинг в подсеть centralServer через centralRouter:
`ip route add 192.168.0.0/30 via 192.168.255.2`

Прописываем правила для iptables, прокидывающие порт 8080 inetRouter2 на порт 80 centralServer
```
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 8080 -j DNAT --to-destination 192.168.0.2:80
iptables -t nat -A POSTROUTING -j MASQUERADE
```
Проверяем: http://127.0.0.1:8080, получаем тестовую страничку nginx

5) дефолт в инет оставить через inetRouter

утилитой `mtr` проверяем маршрутизацию в интернет с centralServer

```
                               My traceroute  [v0.85]
centralServer (0.0.0.0)                                    Sun Aug 19 15:56:01 2018
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                           Packets               Pings
 Host                                    Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. 192.168.0.1                           0.0%     8    0.4   0.7   0.4   1.4   0.0
 2. 192.168.255.1                         0.0%     8    1.0   0.8   0.4   1.1   0.0
 3. ???
 4. WL-BCEE7B978A31                       0.0%     8    2.7   2.0   1.2   2.7   0.0
 5. 192.168.100.1                         0.0%     8    2.4   2.3   1.8   2.8   0.0
 6. ip.178-69-32-1.avangarddsl.ru         0.0%     8    8.2   7.4   3.0   9.5   2.1
 7. ???
 8. ???
 9. bbn.212-48-204-221.nwtelecom.ru       0.0%     8    5.5   5.9   4.4   7.5   1.0
10. bbn.212-48-204-187.nwtelecom.ru       0.0%     8    6.6   7.6   4.6  15.7   3.4
11. ppp-166.as001.spbnit.ru               0.0%     7    4.4   6.6   4.4   9.3   1.7
12. ???
13. ppp-189.as001.spbnit.ru               0.0%     7    6.9  55.9   6.9 190.2  66.8
14. ae2-30g.T1600-2-MMT.nwtelecom.ru      0.0%     7    4.4  38.6   4.4 155.8  55.5
15. ae3-30g.MX960-1-MMT.nwtelecom.ru      0.0%     7    5.4  82.7   4.8 234.6  81.0
16. as13238-yandex.gateway.nwtelecom.ru   0.0%     7    7.9  55.3   6.1 139.3  50.5
17. m9-p2-100ge-2-0-3.yndx.net            0.0%     7   17.3  55.2  15.3 104.1  34.9
18. ???
19. ???
20. vla1-1d2-eth-trunk4-1.yndx.net        0.0%     6   20.0  33.0  19.3  91.8  28.8
21. ???

```
Видим, что трафик идет через 192.168.255.1, что является адресом inetRouter1



