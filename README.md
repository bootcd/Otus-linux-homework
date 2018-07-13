
Домашнее задание
разворачиваем сетевую лабораторию
## Дано
https://github.com/erlong15/otus-linux/tree/network
(ветка network)

Vagrantfile с начальным построением сети
- inetRouter
- centralRouter
- centralServer

Итого должны получится следующие сервера
- inetRouter
- centralRouter
- office1Router
- office2Router
- centralServer
- office1Server
- office2Server

## Практическая часть
- Соединить офисы в сеть согласно схеме и настроить роутинг
- Все сервера и роутеры должны ходить в инет черз inetRouter
- Все сервера должны видеть друг друга
- у всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи
- при нехватке сетевых интервейсов добавить по несколько адресов на интерфейс

В бранче присутствует [Vagrantfile](https://github.com/bootcd/Otus-linux-homework/blob/Network_basics/Vagrantfile)

Построенная виртуальная среда на его основе соответствует требуемой в ДЗ
