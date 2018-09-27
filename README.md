## Домашнее задание
простая связь через pjsip
установить астериск на сервере 
для ус тановки воспользоваться ролью https://github.com/erlong15/tls-asterisk14-ansible
при установке создаются 3 номер 1100, 1101, 1102
подключить два телефона (можно использовать transport-tls, transport-udp, transport-tcp)
сделать звонок
в качестве ДЗ принимается лог SIP сессии

при использовании вагранта и внешних телефонов можно использовать варианты
- виртуалки с телефонами в одной приват сети с астериском
- бридж интерфейс для проброса во вне


1. Развернул asterisk сервер с помощью [роли](https://github.com/erlong15/tls-asterisk14-ansible)
2. Пробросил бридж-интерфейс.
3. На хостовую машину установил 2 программных телефона `PhonerLite` и `MicroSIP`.
4. Запросом в базу, как описано в Readme роли узнал пароли экстеншенов 1100 и 1101
5. Настроил программные телефоны на эти экстеншены через `transport-tls`, так как ранее ни разу такого не делал в своих сеттингах.
6. Для нормальной работы, на телефоне PhonerLite, пришлось включить `SRTP` без этого получал при наборе номера `448: not acceptable here`
7. Произвел звонок с номера 1100 на номер 1101

Лог [SIP сессии](https://github.com/bootcd/Otus-linux-homework/blob/asterisk/Sip%20%D1%81%D0%B5%D1%81%D1%81%D0%B8%D1%8F.txt): 
```
[root@pbxServer vagrant]# asterisk -rvvvv
Asterisk 14.7.8, Copyright (C) 1999 - 2016, Digium, Inc. and others.
Created by Mark Spencer <markster@digium.com>
Asterisk comes with ABSOLUTELY NO WARRANTY; type 'core show warranty' for details.
This is free software, with components licensed under the GNU General Public
License version 2 and other licenses; you are welcome to redistribute it under
certain conditions. Type 'core show license' for details.
=========================================================================
Connected to Asterisk 14.7.8 currently running on pbxServer (pid = 1090)
    -- Added contact 'sip:1101@192.168.1.134:51447;transport=TLS;ob' to AOR '1101' with expiration of 300 seconds
  == Contact 1101/sip:1101@192.168.1.134:51447;transport=TLS;ob has been created
  == Endpoint 1101 is now Reachable
    -- Contact 1101/sip:1101@192.168.1.134:51447;transport=TLS;ob is now Unknown.  RTT: 0.000 msec
  == Setting global variable 'SIPDOMAIN' to '192.168.1.119'
    -- Executing [1101@default:1] Dial("PJSIP/1100-00000000", "PJSIP/1101") in new stack
    -- Called PJSIP/1101
    -- PJSIP/1101-00000001 is ringing
       > 0x7fe5e80f8ce0 -- Strict RTP learning after remote address set to: 192.168.1.134:4000
    -- PJSIP/1101-00000001 answered PJSIP/1100-00000000
       > 0x7fe5e8106600 -- Strict RTP learning after remote address set to: 192.168.1.134:5062
    -- Channel PJSIP/1101-00000001 joined 'simple_bridge' basic-bridge <bae29a89-7c02-4279-a38f-8b718e9ccd4f>

    -- Channel PJSIP/1100-00000000 joined 'simple_bridge' basic-bridge <bae29a89-7c02-4279-a38f-8b718e9ccd4f>

       > 0x7fe5e8106600 -- Strict RTP switching to RTP target address 192.168.1.134:5062 as source
       > 0x7fe5e80f8ce0 -- Strict RTP switching to RTP target address 192.168.1.134:4000 as source
       > 0x7fe5e8106600 -- Strict RTP learning complete - Locking on source address 192.168.1.134:5062
       > 0x7fe5e80f8ce0 -- Strict RTP learning complete - Locking on source address 192.168.1.134:4000
    -- Channel PJSIP/1100-00000000 left 'simple_bridge' basic-bridge <bae29a89-7c02-4279-a38f-8b718e9ccd4f>
  == Spawn extension (default, 1101, 1) exited non-zero on 'PJSIP/1100-00000000'
    -- Channel PJSIP/1101-00000001 left 'simple_bridge' basic-bridge <bae29a89-7c02-4279-a38f-8b718e9ccd4f>
pbxServer*CLI>

```
8. Дополнительно подключал устройства VOiP-шлюзы linksys, тестировал на них. Вполне удачно.
