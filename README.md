
## Домашнее задание
#### Почта
1. Установить в виртуалке postfix+dovecot для приёма почты на виртуальный домен любым обсужденным на семинаре способом
2. Отправить почту телнетом с хоста на виртуалку
3. Принять почту на хост почтовым клиентом

#### Результат
1. Полученное письмо со всеми заголовками
2. Конфиги postfix и dovecot


## Выполнение:

#### 1. Установить в виртуалке postfix+dovecot для приёма почты на виртуальный домен любым обсужденным на семинаре способом

Вариант `Postfix - MTA + LDA, Dovecot - MDA`

Вносим необходимые редакции в файл [master.cf](https://github.com/bootcd/Otus-linux-homework/blob/mail/master.cf)

`192.168.11.101:smtp      inet  n       -       n       -       -       smtpd` - указываем на каком адресе слушать демону `smtp`

Вносим необходимые редакции в файл [main.cf](https://github.com/bootcd/Otus-linux-homework/blob/mail/main.cf)

1. Задаем имя виртуального домена:

`virtual_mailbox_domains = bootmail.com`, где `bootmail.com` - наш виртуальный домен.

(Для правильного разрешения имен в тестовой средя я установил DNS сервер BIND и настроил необходимые записи на адрес 192.168.11.101 - адрес рабочей сетевой карты машины)

2. Задаем настройки для карт виртуальных ящиков `virtual_mailbox_maps`

`virtual_mailbox_maps = mysql:/etc/postfix/sql/virtual_mailbox_recipients.cf`

В моей случае для хранения информации о виртуальных почтовых ящиках я использовал сервер MariaDB.
В файле `virtual_mailbox_recipients.cf`, указываются парметры для запроса в базу для нахождения информации о виртуальном ящике:

```
user = root
password = 100500
dbname = mail
table = virtual_users
select_field = virtual_mailbox
where_field = email
additional_conditions = and active = '1'
hosts = localhost
```
3. Задаем настройки для карт виртуальных алиасов (postmaster и abuse):

`virtual_alias_maps = mysql:/etc/postfix/sql/virtual_alias_maps.cf`
В файле `virtual_alias_maps.cf`, указываются парметры для запроса в базу для нахождения информации об алиасах:

```
user = root
password = 100500
dbname = mail
table = virtual_aliases
select_field = virtual_user_email
where_field = alias
hosts = localhost
```
4. Вносим информацию о uid и guid для виртуального пользователя для доступа к почтовым ящикам: `vuser` (5000:5000)

```
virtual_uid_maps = mysql:/etc/postfix/sql/virtual_uid_maps.cf
virtual_gid_maps = mysql:/etc/postfix/sql/virtual_gid_maps.cf
```
В обоих файлах указываем данные для sql запроса в БД для получения uid и guid соответственно.

5. Указываем каталог хранения для почтовых ящиков:

`virtual_mailbox_base = /var/spool/virtual_mailboxes`

выдаем права на этот каталог пользователю `vuser`

6. Стартуем сервисы `postfix` и `mariaDB`

7. Заносим ифнормацию в БД:

Виртуальный ящик: `bootcd@bootmail.com`

Виртуальный домен: `bootmail.com`

Алиасы `abuse@bootmail.com` и `postmaster@bootmail.com` указывают на `bootcd@bootmail.com`

Указываем что ящик активен: `1`

etc

(Схему БД я брал из официальной документации)

#### 2. Отправить почту телнетом с хоста на виртуалку

1. Пробуем отправить через `telnet` почту с хоста. Для этого я пробросил порт `2223` на порт `25` "слушающего" адреса сервера `postfix`

2. Получаем такой диалог:
![](https://github.com/bootcd/Otus-linux-homework/blob/mail/telnet%20mail.jpg)

3. Сомтрим в полученное письмо:

```
From test@test.com  Sun Oct  7 06:36:11 2018
Return-Path: <test@test.com>
X-Original-To: bootcd@bootmail.com
Delivered-To: bootcd@bootmail.com
Received: from bootcd (gateway [10.0.2.2])
        by otuslinux.localdomain (Postfix) with SMTP id 12E352061599
        for <bootcd@bootmail.com>; Sun,  7 Oct 2018 06:34:10 +0000 (UTC)
subject: This is just test!
from: Tester <test@test.com>
to: bootcd <bootcd@bootmail.com>


Hi there! This is telnet session test!
by!

```

#### 3. Принять почту на хост почтовым клиентом
 Настраиваем dovecot
 
 В файле [dovecot.conf](https://github.com/bootcd/Otus-linux-homework/blob/mail/dovecot.conf)
 
указываем какие протоклы он будет обслуживать:

`protocols = imap`

В файле: [10-auth.conf](https://github.com/bootcd/Otus-linux-homework/blob/mail/10-auth.conf)

`disable_plaintext_auth = no` #### Даем возможность использовать текстовые пароли

 В файле [auth-passwdfile.conf.ext](https://github.com/bootcd/Otus-linux-homework/blob/mail/auth-passwdfile.conf.ext)
 
указываем файлы в которых будут находиться данные о наших ящиках.

Чтобы не хранить пароли в котрытом виде шифруем их. Используем формат имени пользователя без @bootmail.com

Используем для этого файл [users](https://github.com/bootcd/Otus-linux-homework/blob/mail/users)

```
passdb {
  driver = passwd-file
  args = scheme=sha512-CRYPT username_format=%u /etc/dovecot/users
}

userdb {
  driver = passwd-file
  args = username_format=%u /etc/dovecot/users
  ```
В файле [10-ssl.conf](https://github.com/bootcd/Otus-linux-homework/blob/mail/10-ssl.conf)

Принудительно выставляем `ssl = no` для возможности потестировать без SSL инфраструктуры с удаленной машины.

В файле [10-master.conf](https://github.com/bootcd/Otus-linux-homework/blob/mail/10-master.conf)

выставляем порт для IMAP

```
service imap-login {
  inet_listener imap {
    port = 143
  }
  ```
 В файле [10-mail.conf](https://github.com/bootcd/Otus-linux-homework/blob/mail/10-mail.conf)
 
 Прописываем где и как dovecot будет искать файлы почтовых ящиков
 
 `mail_location = mbox:/var/spool/virtual_mailboxes:INBOX=/var/spool/virtual_mailboxes/%u`
 
 А так же разрешения на доступ нашему пользователю vuser (5000:5000)
 
 ```
first_valid_uid = 5000
last_valid_uid = 5000

first_valid_gid = 5000
last_valid_gid = 5000
```
Перезапускаем dovecot и пытаемся подключиться почтовым IMAP клиентом к серверу:
![](https://github.com/bootcd/Otus-linux-homework/blob/mail/thunderbird.jpg)

Видим, что письмо отображается в папке `Inbox` (Наряду с письмами времен отладки конфигурации)
