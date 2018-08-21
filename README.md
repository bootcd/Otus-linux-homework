## Домашнее задание.
Реализовать ДЗ по iptables через ansible

#### 2-5)
Для проверки задания необходимо:

1) склонить папку [2-5](https://github.com/bootcd/Otus-linux-homework/tree/ansible/2-5) данного бранча, развернуть виртуальную ифнраструктуру на основе [VagrantFile](https://github.com/bootcd/Otus-linux-homework/blob/ansible/2-5/Vagrantfile)

2) Зайти на машину `ansibleServer` и выполнить команду из домашнего каталога пользователя vagrant: 

`ansible-playbook -c paramiko -i hosts nginx_publishing.yml --ask-pass --sudo`

Использовать пароль: `vagrant`

Проверить можно через переход по ссылке http://127.0.0.1:8080
