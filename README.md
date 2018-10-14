## Домашнее задание
Развернуть базу из дампа и настроить для нее реплику
В материалах приложены ссылки на вагрант для репликации
и дамп базы bet.dmp
базу развернуть на мастере
и настроить чтобы реплицировались таблицы
| bookmaker |
| competition |
| market |
| odds |
| outcome

* Настроить GTID репликацию

варианты которые принимаются к сдаче
- рабочий вагрантафайл
- скрины или логи SHOW TABLES
* конфиги
* пример в логе изменения строки и появления строки на реплике
Критерии оценки: 5 - сделана домашка
6 - настроена GTID репликация

Выполнение.
Я использовал свой стенд, основанный на дистрибутиве ubuntu 12.04 LTS x64

1. Поднимаем 2 машины на `ubuntu 12.04 LTS x64` c IP адресами `master - 192.168.1.244`, `slave - 192.168.1.149`
2. На каждой устанавливаем из репозиториев пакеты `mysq-server` и `mysql-client`
3. В процессе установки прописываем пароль `root` для `mysql`
4. Скачиваем дам базы из материалов занятия.
5. Создаем базу, в котрую будем разворачивать дамп:
```
mysql> create database bet_odds;
```
6. Разворачиваем дамп на машине - мастере:
```
mysql -u root -p bet_odds < bet.dmp 
```
7. После того как дамп развернется начинаем править конфиги для создания репликации.

В файле [etc/mysql/my.cnf](https://github.com/bootcd/Otus-linux-homework/blob/mysql/master/my.cnf) в секции `[mysqld]` добавим:
```
server-id = 1
log_bin = /var/lib/mysql/mysql-bin.log  # место хранения бинлога
binlog_do_db = bet_odds # какая база будет реплицирована.
```
8. Создадим пользователя c правами на репликацию:
```
GRANT replication slave ON "bet_odds".* TO "repl"@"192.168.1.149" IDENTIFIED BY "100500";
```

9. Перезапускаем mysql.

10. Выполняем команду:
`SHOW MASTER STATUS\G`

получаем такой вывод:
![](https://github.com/bootcd/Otus-linux-homework/blob/mysql/masterstatus.jpg)
Эти данные нам будут нужны для настройки репликации на сервере-реплике.

11.Делаем дамп базы на мастере:
```
mysqldump -u root -p bet_odds > bet_master.dmp
```
И останавливаем сервер. (Можно блокировать на запись).

12. Переносим дамп на сервер-реплику и там его разворачиваем в базу `bet_odds`

12. Вносим правки в конфигурационный файл [/etc/mysql/my.cnf](https://github.com/bootcd/Otus-linux-homework/blob/mysql/slave/my.cnf) в секции `[mysql]`
```
server-id = 2
binlog_do_db = bet_odds
replicate-ignore-table = bet_odds.events_on_demand
replicate-ignore-table = bet_odds.v_same_event 
```
13. перезапускаем сервер

14. Выполняем команду для построения репликации:
```
CHANGE MASTER TO MASTER_HOST = "192.168.1.244 ", MASTER_USER = "repl", MASTER_PASSWORD = "100500", MASTER_LOG_FILE = "mysql-bin.000032 ", MASTER_LOG_POS = 1946;
```
`MASTER_LOG_FILE` и `MASTER_LOG_POS` берем от мастера.

15. Запускаем slave:
`start slave`

16. Смотрим статус слейва:
![](https://github.com/bootcd/Otus-linux-homework/blob/mysql/slavestatus.jpg)

Видим, что сервер-реплика, понимает какие таблицы не надо реплицировать.

## ПРОВЕРКА РЕПЛИКАЦИИ

Добавим в таблицу bookmakers нового букмекера: `ultrabet!`
![](https://github.com/bootcd/Otus-linux-homework/blob/mysql/replication.jpg)

Видим, что наш новый букмекер `ultrabet!` появился в таблице.

17. На мастере (слева) видно, что количество записей в таблице bookmakers отличается от количества записей на слейве (справа).
Это сделано, чтобы было понятно, что это разные машины. 

Так же это иллюстррует  почему необходимо блокировать базу мастера на запись или отсанавливать сервер. 
Изменения были внесены после снятия дампа базы для переноса на слейв, но новые значения `MASTER_LOG_FILE` и `MASTER_LOG_POS` не были взяты с мастера, а использовались предыдущие.
