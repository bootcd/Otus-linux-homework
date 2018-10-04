
## Домашнее задание

настраиваем бэкап

настроить политику бэкапа каталога /etc с обоих клиентов

1) полный раз в день
2) инкремент каждые 10 минут
3) дифференциал каждые полчаса

запустить систему на 2 часа

для сдачи ДЗ приложить

list jobs
list files jobid=<idfullbackup>
и настроенный конфиг
	
#### list files jobid=<169>
![list files jobid=<169>](https://github.com/bootcd/Otus-linux-homework/blob/bacula/listfiles_full.jpg)
  
  



#### Выполнение:

Установку и настройку делал сам с нуля.
1. Установка всех служб bacula (bacula-dir, bacula-sd, bacula-fd)
2. Установка MariaDB
3. Выполнение послеустановочных скриптов первоначальной настройки.
4. Редактируем файл [bacula-dir.conf](https://github.com/bootcd/Otus-linux-homework/blob/bacula/bacula-dir.conf)

Я убрал практически все дефолтные конфиги, написал свои:
```
Director {                           
  Name = main-dir
  DIRport = 9101              
  QueryFile = "/etc/bacula/query.sql"
  WorkingDirectory = "/var/spool/bacula"
  PidDirectory = "/var/run"
  Maximum Concurrent Jobs = 1
  Password = "100500"     
  Messages = Daemon
  DirAddress = 192.168.255.1
}

Job {
  Name = "BackupClient1"
  type = Backup
  Client = Client1
  Fileset = "etc"
  Schedule = "etc"
  Messages = message
  Pool = File
}

Job {
  Name = "BackupClient2"
  type = Backup
  Client = Client2
  Fileset = "etc"
  Schedule = "etc"
  Messages = message
  Pool = File
}

FileSet {
  Name = "etc"
  Include {
    Options {
    recurse = yes

}
   File = "/etc"
	}
}

Schedule {
  Name = "etc"
  Run = Level = Full daily at 09:20
  Run = Level = Incremental hourly at 00:00
  Run = Level = Incremental hourly at 00:10
  Run = Level = Incremental hourly at 00:20
  Run = Level = Incremental hourly at 00:30
  Run = Level = Incremental hourly at 00:40
  Run = Level = Incremental hourly at 00:50
  Run = Level = Differential hourly at 00:15
  Run = Level = Differential hourly at 00:45
}

Client {
 Name = Client1
 Address = 192.168.255.2
 Catalog = MySql
 FDPort = 9102
 Password = "100500"
 }

Client {
 Name = Client2
 Address = 192.168.255.3
 Catalog = MySql
 FDPort = 9102
 Password = "100500"
 }

Storage {
  Name = File
  Address = 192.168.255.1
  SDPort = 9103
  Password = "100500"
  Device = FileStorage
  Media Type = File
}

Catalog {
  Name = MySql
  dbname = "bacula"; dbuser = "bacula"; dbpassword = "19811981"
}

Messages {
  Name = Daemon
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula daemon message\" %r"
  mail = root@localhost = all, !skipped            
  console = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
}

Messages {
  Name = message
  mailcommand = "/usr/sbin/bsmtp -h localhost -f \"\(Bacula\) \<%r\>\" -s \"Bacula Jobs message\" %r"
  mail = root@localhost = all, !skipped
  console = all, !skipped, !saved
  append = "/var/log/bacula/bacula.log" = all, !skipped
}

Pool {
  Name = Default
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 365 days         # one year
}

Pool {
  Name = File
  Storage = File
  Pool Type = Backup
  Recycle = yes                       # Bacula can automatically recycle Volumes
  AutoPrune = yes                     # Prune expired volumes
  Volume Retention = 365 days         # one year
  Maximum Volume Bytes = 50G          # Limit Volume size to something reasonable
  Maximum Volumes = 100               # Limit number of Volumes in Pool
}
```
В клиентах указываем две другие машины: `Client1 - 192.168.255.2, Client2 - 192.168.255.3`
Уровни бекапа указываем в `Schedule`

Редактируем файлы [bacula-sd.conf](https://github.com/bootcd/Otus-linux-homework/blob/bacula/bacula-sd.conf) и [bacula-fd.conf](https://github.com/bootcd/Otus-linux-homework/blob/bacula/bacula-fd.conf)

5. Вносим изменения в файл [bconsole.conf](https://github.com/bootcd/Otus-linux-homework/blob/bacula/bconsole.conf)

```
Director {
  Name = bacula-dir
  DIRport = 9101
  address = 192.168.255.1
  Password = "100500"
}
```
6. Установливаем клиент bacula на клиентские машины:

`yum install bacula-client`

7. Редактируем файлы bacula-fd.conf на клиента, правим секцию Director:

```
Director {
  Name = main-dir
  Password = "100500"
}
```
8. Запускаем сервис: `service bacula-fd start` на обоих клиентах.

9. В консоли `bconsole` необходимо создать с омощью команды `label`том для хранения. В моейм случае: `MyVolume`

10. Запускаем службы bacula, Ждем 2 часа.
