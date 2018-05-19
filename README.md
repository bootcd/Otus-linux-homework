### уменьшить том под / до 8G

#### 1.Загружаемся с установочного диска в режиме rescue
#### 2.Создаем на одном из доступных пустых дисков раздел для бекапа корня, размечаем в xfs
#### 3.Корень нашей системы находится в /mnt/sysimage и примонтирован в /dev/VolGroup00/LogVol00 xfs
#### 4.Отмонтируем его:
 `umount -l /mnt/sysimage`
#### 5.Создадим каталог для бекапа файловой системы корня
 `mkdir /buroot`
#### 6.Смонтруем его в подготовленный ранее раздел /dev/sdb xfs
 `mount /dev/sdb1 /buroot`
#### 7.Создадим образ lvm тома и положим в каталог /buroot
 `dd if=/dev/VolGroup00/LogVol00 of=/buroot/buroot.img`  
Для экономии времени и пространства можно задать размер блока для dd и сжимать образ на лету.
Я делал несколько раз разными способами.
#### 8.Удалим старый lvm том
 `lvremove /dev/VolGroup/LogVol00`
#### 9.Создадим новый lvm том на 8 Gb
 `lvcreate -L 8G -n LogVol00 /dev/VolGroup00`
#### 10.Монтируем корень обратно в новый том
 `mount /dev/VolGroup00/LogVol00 /mnt/sysimage`
#### 11.Монтируем /buroot/buroot.img через loop в заранее подготовленный каталог /burootimg
 `mkdir /burootimg`
 `mount -o loop /buroot/buroot.img /burootimg`
12.Копируем содержимое образа в каталог /mnt/sysimage с сохранением прав
 cp -a -R /burootimg/ /mnt/sysimage
13. Перезагружаем машину. входим и видим, что том под / имеет размер 8Gb

выделить том под /home
 lvcreate -L 1G -n lv_home /dev/VolGroup00
 mkfs.xfs /dev/VolGroup00/lv_home

выделить том под /var
 lvcreate -L 1G -n lv_var /dev/VolGroup00
 mkfs.xfs /dev/VolGroup00/lv_var

/var - сделать в mirror

1. Добавляем несколько новых разделов в lvm группу, предварительно разметив их через fdisk
 pvcreate /dev/sdc1 /dev/sdd1
 vgextend /dev/VolGroup00 /dev/sdc1 /dev/sdd1
2. Конвертируем lv_var в зеркало
  lvconvert -m 1 /dev/VolGroup00/lv_var /dev/sda3 /dev/sdc1 /dev/sdd1

/home - сделать том для снэпшотов
 lvcreate -L 2G -s -n snaphot_lv_home /dev/VolGroup00/lv_home

прописать монтирование в fstab
1.Копируем содержимое /home и /var в /dev/VolGroup00/lv_home и /dev/VolGroiup00/lv_var соответсвенно, с сохранением прав, предварительно примонтировав каждый lм раздел в /mnt
2.Прописываем точки монтирования в /etc/fstab
 /dev/VolGroup00-lv_home /home xfs defaults 0 0
 /dev/VolGroup00-lv_var /var xfs defaults 0 0
3.Монтируем
 mount -a

сгенерить файлы в /home/
 #!/bin/bash
i=0
while [ $i -lt 22 ]
do
  touch $i
  i=$[$i+1]
done

снять снэпшот
 lvcreate -L 2G -s -n snap1_lv_home /dev/VolGroup00/lv_home
 
удалить часть файлов
 rm 0 1 5 7 9

восстановится из снэпшота
 umount /home
 lvconvert --merge /dev/Volgroup00/snap1_lv_home
 mount /dev/Volgroup00/lv_home /home
удаленные файлы вернулись.


