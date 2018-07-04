
## 1) создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями)
## 2) создать свой репо и разместить там свой RPM реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо 

#### 1. Сборка RPM пакета на примере `cobbler` (сервер сетевой установки Linux)*

Нашел src.rpm пакет с нужной версией на http://ftp.redhat.com/

Забираем пакет: `wget http://ftp.redhat.com/redhat/linux/enterprise/7Client/en/RHNTOOLS/SRPMS/cobbler-2.0.7-42.el7sat.src.rpm`

Подготавливаем окружение для сборки:

`yum install rpmbuild rpmdevtools`

создаем дерево каталогов:

`devtools-setuptree`

Производим установку нашего src.rpm пакета:

`rpm -Uhv cobbler-2.0.7-42.el7sat.src.rpm`

получаем следующие пути: 

`rpmbuild/SPECS/cobbler.spec`

`rpmbuild/SOURCES/cobbler-2.0.7.tar.gz` + набор патчей

В файле `/rpmbuld/SPECS/cobbler.spec` с целью изучения механизма сборки производились разные модификации, например смена требуемой версии интерпретатора python или удаление требуемых патчей из каталога и дальнейшая их выписка из спек-файла. В основном после подобных экспериментов пакет ожидаемо не собирался, не устанавливался или установившись не работал.

Производим сборку с "заводским" спек-файлом:

`rpnbuild -bb cobbler.spec`

Сразу происходит остановка процесса и указание на отсутствие необходимых зависимостей, в основном свзанных с python.
Устанавливаем зависимости из стандартного репозитария. Запускаем сборку еще раз - на этот раз успешно!
\
В каталоге `rpmbuild/RPMS/` видим 3 rpm пакета относящихся к серверу cobbler.

#### 2. Создание своего репозитария и размещение собранных пакетов на нем

Я использовал стандратный дроплет Centos7 на Digital Ocean

Устанавливаем туда Nginx и производим все необходимые действия для настройки доступа.

Создаем репо:

`createrepo  /var/www/myrepo/Centos/7/`

отправляем в каталог `/var/www/myrepo/Centos/7/repodata` ранее собранные пакеты

"пересобираем" репозитарий:

`createrepo  --update /var/www/myrepo/Centos/7/`

На своей машине в каталоге `/etc/yum.repos.d/` создаем файл Myrepo.repo следующего содержания:

```
[myrepo]
name=MyRepo
baseurl=http://67.205.176.42/Centos/7/
enabled=1
gpgcheck=0
priority=1
```
Выполняем: `yum provides cobbler`, получаем такой вывод:

```
cobbler-2.0.7-42.el7.centos.noarch : Boot server configurator
Repo        : myrepo
```
Выполняем: `yum install cobbler` установка не проходит, ошибка - отсуствие пакета `python-simplejson`
Его можно поставить руками, а можно взять, подключив epel - там он есть. После чего установка проходит в штатном режиме.

РЕпозитарий лежит по адресу : http://67.205.176.42/Centos/7/

----------------
\* Я взял этот пакет для примера так как в свое время устанавливал из исходников конкретную его версию, вручную удовлетворяя зависимости и тп. Вариант подобной сборки rpm и размещение его на своем репо с последующей установкой наглядной показал мне насколько это удобнее при наличии готового или хотя бы вменяемого spec файла, по которому можно отследить механизм сборки и осознанно влиять на нее.
