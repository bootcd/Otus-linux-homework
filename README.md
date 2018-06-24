
## Systemd
1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig

2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
3. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами

#### 1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig

Создаем шелл-скрипт [grepper.sh](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/1/grepper.sh), который каждые 30 секунд мониторит файл заданный в параметрах как `$FILE` на предмет слова, которое тоже задается через параметр `$WORD`
В каталоге `/etc/systemd/system` создаем unit файл [grepper.service](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/1/grepper.service). В параметре EnvironmentFile указываем путь к переменным окружения сервиса файл [/etc/sysconfig/grepper.conf](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/1/grepper.conf).
Результат работы скрипта - мониторинг в файле `/var/log/messages` слова `Started` пишется в файл `/var/log/greplog`

#### 2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.

Установим в систему репозиторий Epel и программу spaw-fcgi с компонентами, необходимыми для ее запуска
```
sudo yum install -y epel-release
sudo yum install -y spawn-fcgi php php-cli mod_fcgid
```
Создадим unit файл [spawn-fsgi.service](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/2/spawn-fsgi.service)
В файле `/etc/sysconfig/spawn-fcgi` раскомментируем строчки с параметрами SOCKET и OPTIONS.
Запускаем `sudo service spawn-fsgi start`. Проверяем  `sudo service spawn-fsgi status` - сервис запущен.


#### 3. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами

Создадим 2 разных конфига для апача: [/etc/httpd/conf/httpd-conf2.conf](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/3/httpd-conf2.conf) и [/etc/httpd/conf/httpd-conf3.conf](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/3/httpd-conf3.conf). 

В первом случае апач будет слушать на стандартном 80 порту, во втором на порту 9000.

Для запуска нескольких инстансов будем использовать технологию шаблонов unit файлов.

Создадим шаблон [httpd@.service](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/3/httpd%40.service)

Создадим файлы окружения для каждого запускаемого инстанса [/etc/sysconfig/httpd-conf2](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/3/httpd-conf2.conf) и [/etc/sysconfig/httpd-conf3](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/3/httpd-conf3.conf)

Создадим таргет юнит файл [httpd.target](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/3/httpd.target)
Запускаем `service httpd.target start`

через `ps ax | grep httpd` видим, что запущено одновременно 2 инстанса httpd с конфигами httpd-conf2.conf и httpd-conf3.conf
