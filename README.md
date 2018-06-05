
## Домашнее задание №5 Bash

В ДЗ представлено 2 скрипта.

`1. astelist.sh`

Скрипт предназначен для парсинга файла Master.csv сервера Asterisk. В файле содержится информация о совершенных звонках
Задача скрипта составить простой отчет (кто звонил, куда звонил, когда, продолжительность звонка, статус) и подсчитать количество совершенных исходящих и полученных входящих звонков за отведенный промежуток времени в рамках 1 суток
Скрипт создает csv файл с журналом и выводит в стадартный поток вывода калькуляцию количества звонков с указанием внутренних и внешних номеров.
Формат запуска скрипта

`./astelist.sh -d yyy-mm-dd -t hh:mm:ss hh:mm:ss`

Пример запуска скрипта с ключами и параметрами:

`./astelist.sh -d 2018-05-28 -t 09:20:00 12:25:00`

В этом случае будет создан csv файл с записями о звонках в промежутке от 9 часов 20 минут до 12 часов 25 минут 28 мая 2018 года.
Будет выведена информация о количествах совершенных и полученных звонков.

Допускается запуск без параметров, относящихся к ключу `-t`.
Если будет отсуствовать параметр,означающий коненчое время выборки, будет осуществлена выдача информации с указанного в первой позиции времени до 23 часов 59 минут и 59 секунд заданых суток. При отсуствии обоих параметров, будет произведен поиск информации с 0 часов 0 минут и 0 секунд до 23 часов 59 минут 59 секунд указанных суток.

В скрипте предусмотрена проверка на некорректный ввод вечелин суток и временного диапазона.

Путь к файлу Master.csv и csv файлу с рещультами парсинга задаются в блоке переменных (variables block)

Скрипт читает файл Master.csv построчно, разбивает его на составляющие, производит необходимые служебные вычисления, основаные на сравнении переданных ему велечин в качестве параметров с имеющимися записями в файле и принимает то или иное решение.


`2.watch.sh`

Скрипт предназначен для отслеживания состояния переданных ему служб и в случае их неактивного состояния производит запуск.
Список отслеживаемых служб передается в текстовом файле. Имена служб разделены знаком перевода строки.
Скрипт очуществляет чтение файла и проверяет `status` каждой службы. В случае получения в статус `inactive`, происходит запуск службы через `service start`

Информация о событиях запуска или нормальной работы записывается в журнал по пути `/var/log/watchlog`

Текст ошибок в случае неудачного запуска передаются в `/var/log/messages`

В случае нахождения хотя бы 1 или более службы в состоянии `inactive` происходит попытка ее запуска и отправка письма администратору на почтовый ящик об этом событии с указанием этих служб.

Скрипт можно поставить в cron с частотой запуска по выбору администратора.
