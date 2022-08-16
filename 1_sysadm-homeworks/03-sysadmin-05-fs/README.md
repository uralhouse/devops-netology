### Решение домашнего задания №10 (Файловые системы)

##### Вопрос 1: Узнайте о sparse (разряженных) файлах.

Изучил.

##### Вопрос 2: Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Не могут иметь разные права доступа и владельца.

Жесткая ссылка и файл, для которой она создавалась имеют одинаковые inode. Поэтому жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл. Различаются только имена файлов. Фактически жесткая ссылка это еще одно имя для файла.

##### Вопрос 3: Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

`Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
end`

##### Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

![image-20211126201711753](image/image-20211126201711753.png)

##### Вопрос 4: Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

![image-20211126201836598](image/image-20211126201836598.png)

![image-20211126201841804](image/image-20211126201841804.png)

![image-20211126201850096](image/image-20211126201850096.png)

##### Вопрос 5: Используя sfdisk, перенесите данную таблицу разделов на второй диск.

![image-20211126201937639](image/image-20211126201937639.png)

##### Вопрос 6: Соберите mdadm RAID1 на паре разделов 2 Гб.

![image-20211126202020788](image/image-20211126202020788.png)

##### Вопрос 7: Соберите mdadm RAID0 на второй паре маленьких разделов.

![image-20211126202054807](image/image-20211126202054807.png)

![image-20211126202108800](image/image-20211126202108800.png)

##### Вопрос 8: Создайте 2 независимых PV на получившихся md-устройствах.

![image-20211126202140521](image/image-20211126202140521.png)

##### Вопрос 9: Создайте общую volume-group на этих двух PV.

![image-20211126202210868](image/image-20211126202210868.png)

##### Вопрос 10: Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

![image-20211126202241366](image/image-20211126202241366.png)

##### Вопрос 11: Создайте mkfs.ext4 ФС на получившемся LV.

![image-20211126202320173](image/image-20211126202320173.png)

##### Вопрос 12: Смонтируйте этот раздел в любую директорию, например, /tmp/new.

![image-20211126202356304](image/image-20211126202356304.png)

##### Вопрос 13: Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

![image-20211126202431123](image/image-20211126202431123.png)

##### Вопрос 14: Прикрепите вывод lsblk.

![image-20211126202520602](image/image-20211126202520602.png)

##### Вопрос 15: Протестируйте целостность файла

![image-20211126202601062](image/image-20211126202601062.png)

##### Вопрос 16: Погасите тестовый хост, vagrant destroy.

![image-20211126202640552](image/image-20211126202640552.png)
