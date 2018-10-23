## Домашнее задание
#### Простая защита от DDOS
Написать конфигурацию nginx, которая даёт доступ клиенту только с определенной cookie.
Если у клиента её нет, нужно выполнить редирект на location, в котором кука будет добавлена, после чего клиент будет обратно отправлен (редирект) на запрашиваемый ресурс.

0. Пробросим порт `80` адреса `localhot` с хостовой машины на порт 80 виртуальной на адрес `localhost` 
1. Устанавливаем `nginx`
2. В файле `/etc/nginx/nginx.conf` в секции server прописывваем такие `location`:

`localtion / {} `

Этот локейшн приводит пользователя запросившего `http://localhos`t в дирректорию нашего "сайта". По умолчанию там распологается приветственная страничка Nginx. НО! только в том случае, если запросивший обладает `cookie` c параметром `myid=100500`. В случае отсуствия такой куки, будет произведен редирект на 

`localtion /cookieset.html {}`

В этом локейшене мы будем устанавливать сookie с параметром myid=100500
После, будет произведен редирект на localtion / {}

#### location /{}
```
 location / {
         if ($cookie_myid != "100500"){
                rewrite ^(.*)$ /cookieset.html redirect;
                }
}
```

#### localtion /cookieset{}
```
 location /cookieset.html {
      add_header Set-Cookie myid=100500;
      return 302 http://localhost; 
        }
```

Видим, что кука заходит в браузер:
![](https://github.com/bootcd/Otus-linux-homework/blob/web/3.jpg)


На скриншотах ![1](https://github.com/bootcd/Otus-linux-homework/blob/web/1.JPG) и ![2](https://github.com/bootcd/Otus-linux-homework/blob/web/2.JPG) сессии telnet видно, что при запросе страницы `/` без куки, происходит перенаправление на локейшен `/cookieset.html`, где передается заголовок `Set-Cookie` c параметром `myid=100500`.

При обращении к `/` c куки `myid=100500`, редиректа не происходит и мы сразу видим код приветственной страницы `nginx`
