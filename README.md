
## Домашнее задание
#### PostgreSQL
1. Написать playbook установки postgres.
- в vars вынести версию, так что бы поддерживалась версия 9.6 и 10
- сконфигурировать pg_hba.conf (пересмотрите слайды)
- сконфигурировать postgresql.conf на работу с конкретной машиной (ansible_memtotal_mb вам в помощь)
2. Написать playbook разворачивания реплики с помощью pg_basebackup


Для проверки ДЗ необходимо:
1. Cклонить файлы из бранча
2. Построить виртуальную среду с помощью [Vagrantfile](https://github.com/bootcd/Otus-linux-homework/blob/postgresql/Vagrantfile)
3. Скопировать файлы [hosts](https://github.com/bootcd/Otus-linux-homework/blob/postgresql/hosts), [postgres.yml](https://github.com/bootcd/Otus-linux-homework/blob/postgresql/postgres.yml), [postgresql.conf.j2](https://github.com/bootcd/Otus-linux-homework/blob/postgresql/postgresql.conf.j2), [slave.yml](https://github.com/bootcd/Otus-linux-homework/blob/postgresql/slave.yml) в любой удобный каталог и из него выполнить команду:

```
ansible-playbook -c paramiko -i hosts postgres.yml --ask-pass --sudo

```
на основании плейбука [postgres.yml](https://github.com/bootcd/Otus-linux-homework/blob/postgresql/postgres.yml) произойдет следующее:

- установка postgresql сервера на машины `postgresServer` (основной сервер) и `postgresReplic` (сервер для реплики)
- инициализация кластера
- для мастер-сервера откроется порт tcp 5234, с помощью темплейта [postgresql.conf.j2](https://github.com/bootcd/Otus-linux-homework/blob/postgresql/postgresql.conf.j2) приментися необходимая конфигурация. Далее установятся нужные значения параметров конфигурационного файла, создастся пользователь `replicant`. Для совместимости с версией 10, добавлен параметр `encrypted: yes`.
- произойдет рестарт сервера.

#### ПРИМЕЧАНИЕ
Все необходимые переменные объявлены непосредственно в плейбуке.

Для выбора весии для установки (9.6 или 10) используется следующая конструкция относительно каждой группы хостов.

```
#!!!!!!!!!!!!!!!!
#
# uncomment needful version for Postgresql 9.6 or fo Postgresql 10
#

   #version: 'nine'     #for 9.6
    version: 'ten'      #for 10

```

4. Далее необходимо выполнить следующуу команду:

```
ansible-playbook -c paramiko -i hosts slave.yml --ask-pass --sudo
```
На основании плейбука [slave.yml](https://github.com/bootcd/Otus-linux-homework/blob/postgresql/slave.yml) произойдет следующее:

- установка нужных переменных для конфигурации сервера postgresql на сервере-реплике `serverReplic`
- подготовка сервера-реплики (очистка директории `data`)
- загрузка с сервера-мастера с помощью утилиты pg_basebackup нужных файлов и каталогов:

```
pg_basebackup -h 192.168.255.2 -U replicant -D /var/lib/pgsql/{{pathversion[version]}}/data -R -P -v
```
- с помощью темплейта [postgresql.conf.j2](https://github.com/bootcd/Otus-linux-homework/blob/postgresql/postgresql.conf.j2) произведены необходимые установки дляконфигурационного файла сервера postgresql
- установка дополнительных параметров (`hot_standby = on`)
- Запуск подготовленной конфигурации сервера БД

5. Проверка репликации

Можно проверить работу репликации. 
Я проверял через добавление новой роли на мастере. Через некоторое время она появлялась и на реплике.
