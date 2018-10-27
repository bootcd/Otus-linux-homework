## LDAP
1. Установить FreeIPA
2. Написать playbook для конфигурации клиента
3. Всю "сетевую лабораторию" перевести на аутентификацию через LDAP

Чтобы проверить ДЗ, необходимо склонить бранч и поднять инфраструктуру за счет [Vagrantfile]()
Скопировать файлы [ipa.yml](https://github.com/bootcd/Otus-linux-homework/blob/freeIPA/ipa.yml), [hosts](https://github.com/bootcd/Otus-linux-homework/blob/freeIPA/hosts), [hostsnames/hosts](https://github.com/bootcd/Otus-linux-homework/blob/freeIPA/hostsnames/hosts)
в любую папку машины ansibleServer и выполнить следующую команду:
```
ansible-playbook -c paramiko -i hosts ipa.yml --ask-pass --sudo

```
Результатом исполнения этого плейбука станет установка FreeIPA сервера на машине `ipaserver`, установка необходимых свойств на клиентские машины и установка ipa-клиентов на машины-клиенты.

## Результат выполнения:
1. В консоли IPA сервера мы видим присоединившиеся в домен bootcd.local машины:
![](https://github.com/bootcd/Otus-linux-homework/blob/freeIPA/FreeIPA.JPG)


2. Так же мы можем авторизоваться с помощью доменной учетной записи на клиентской машине:
![](https://github.com/bootcd/Otus-linux-homework/blob/freeIPA/admin.jpg)
