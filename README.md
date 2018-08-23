## Домашнее задание.
Реализовать ДЗ 14 по iptables через ansible

#### 1) Knocking port

Для проверки задания необходимо:

1) склонить папку [1](https://github.com/bootcd/Otus-linux-homework/tree/ansible/1) данного бранча, развернуть виртуальную инфраструктуру на основе [Vagrantfile](https://github.com/bootcd/Otus-linux-homework/blob/ansible/1/Vagrantfile)

2) Зайти на машину `ansibleServer` и выполнить команду из домашнего каталога пользователя vagrant:

`ansible-playbook -i my.inv get_info.yml --ask-vault-pass`

vault-pass: `Aa12345`

3) Зайти на машину `centralRouter` и из домашнего каталога пользователя `vagrant` выполнить команду `./knock_script.sh 192.168.255.1 8881 7777 9991]` и после ее исполнения, проверить доступность машины `inetRouter(192.168.255.1)` по ssh. 


#### 2-5)
Для проверки задания необходимо:

1) склонить папку [2-5](https://github.com/bootcd/Otus-linux-homework/tree/ansible/2-5) данного бранча, развернуть виртуальную ифнраструктуру на основе [VagrantFile](https://github.com/bootcd/Otus-linux-homework/blob/ansible/2-5/Vagrantfile)

2) Зайти на машину `ansibleServer` и выполнить команду из домашнего каталога пользователя vagrant: 

`ansible-playbook -c paramiko -i hosts nginx_publishing.yml --ask-pass --sudo`

Использовать пароль: `vagrant`

Проверить можно через переход по ссылке http://127.0.0.1:8080
