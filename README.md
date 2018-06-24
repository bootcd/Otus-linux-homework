
## Systemd
1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig

2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
3. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами

#### 1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig

Создаем шелл-скрипт [grepper.sh](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/1/grepper.sh), который каждые 30 секунд мониторит файл заданный в параметрах как `$FILE` на предмет слова, которое тоже задается через параметр `$WORD`
В каталоге `/etc/systemd/system` создаем unit файл [grepper.service](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/1/grepper.service). В параметре EnvironmentFile указываем путь к переменным окружения сервиса файл [/etc/sysconfig/grepper.conf](https://github.com/bootcd/Otus-linux-homework/blob/SystemD-%D0%B8-SysV/1/grepper.conf).
Результат работы скрипта - мониторинг в файле `/var/log/messages` слова `Started` пишется в файл `/var/log/greplog`

#### 2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
