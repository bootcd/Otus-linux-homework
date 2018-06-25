## Домашнее задание 
#### работаем с процессами
#### Задания на выбор
## Реализовать 2 конкурирующих процесса по CPU. пробовать запустить с разными nice

В бранче пристуствуют Vagrantfile и скрипт deployment.sh, которые автоматизируют установку и запуск сервисов.

Создадим 2 скрипта [hicpuprior.sh](https://github.com/bootcd/Otus-linux-homework/blob/Processes/hicpuprior.sh) и [lowcpuprior.sh](https://github.com/bootcd/Otus-linux-homework/blob/Processes/lowcpuprior.sh), которые копируют файл `/etc/httpd/conf/httpd.conf` в папку `/home/vagrant` В скриптах укажем время начала копироания и конца и перенаправим вывод в файл `/var/log/cpuprior.log`

 Создадим 2 unit файла [hiprior.service](https://github.com/bootcd/Otus-linux-homework/blob/Processes/hiprior.service), [lowprior.service](https://github.com/bootcd/Otus-linux-homework/blob/Processes/lowprior.service) и таргет файл [cpuconcurent.target](https://github.com/bootcd/Otus-linux-homework/blob/Processes/cpuconcurent.target)
 
 Произведем запуск `service cpuconcurent.target start`
 
Процесс `hiprior.service` запустился с наивысшим приоритетом, в свою очередь `lowprior.service` с наименьшим.


В файле [cpuprior.log](https://github.com/bootcd/Otus-linux-homework/blob/Processes/cpuprior.log) видно, что процесс, запущенный с наивысшим приоритетом отрабатывает много чаще чем процесс с низшим.
