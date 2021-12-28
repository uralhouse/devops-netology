# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Python выполнит вывод, что операция типа  + : 'int' and 'str' не поддерживается (не склеить и не суммировать. Переменная `a` имеет тип "целое число" , переменная `b` имеет тип "строка". |
| Как получить для переменной `c` значение 12?  | Необходимо: откорректировать переменную `a='1'`или объявить переменную 'a' типом "строка", т.е.   `a=str(1)` |
| Как получить для переменной `c` значение 3?  | Необходимо: откорректировать переменную `b=2`,  чтобы объявить переменную 'b' типом "целое число" |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os
dir =  os.path.abspath(os.curdir)
bash_command = ["cd "+dir, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(dir+'/'+prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
alniger@HP:~/netology.devops/04-script-02-py$ python3 test2.py
/home/alniger/netology.devops/04-script-02-py/README.md
/home/alniger/netology.devops/04-script-02-py/test1.py
/home/alniger/netology.devops/04-script-02-py/test2.py
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os
import sys

if sys.argv[1:]:
    dir = sys.argv[1]
else:
    print("Не задан входной параметр (Полный путь до директории с Git репозиторием)")
    exit(1)

if not os.path.isdir(dir+'.git'):
    print("1)В директории отсутствует Git репозиторий")
    print("2)Директория не существует")
    print("3)Задан неверный путь до директории Git-репозитория")
    print("4)Путь до директории с Git репозиторием указан в конце без \"/\"")

else:
    print("Чтение репозитория локальной папки: "+dir)
    bash_command = ["cd "+dir, "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    if 'modified' in result_os:
        for result in result_os.split('\n'):
            if result.find('modified') != -1:
                prepare_result = result.replace('\tmodified:   ', '')
                print('Modified: '+dir+prepare_result)
    else: 
        print("Модифицированных файлов в репозитории нет!")
```

### Вывод скрипта при запуске при тестировании:
```
alniger@HP:~/netology.devops/04-script-02-py$ ./test3.py
Не задан входной параметр (Путь до директории с Git репозиторием)
alniger@HP:~/netology.devops/04-script-02-py$ ./test3.py qeqwqweqwe
1)В директории отсутствует Git репозиторий
2)Директория не существует
3)Задан неверный путь до директории Git-репозитория
4)Путь до директории с Git репозиторием указан в конце без "/"
alniger@HP:~/netology.devops/04-script-02-py$ ./test3.py ~/netology.devops/04-script-02-py
1)В директории отсутствует Git репозиторий
2)Директория не существует
3)Задан неверный путь до директории Git-репозитория
4)Путь до директории с Git репозиторием указан в конце без "/"
alniger@HP:~/netology.devops/04-script-02-py$ ./test3.py ~/netology.devops/04-script-02-py/
Чтение репозитория локальной папки: /home/alniger/netology.devops/04-script-02-py/
Modified: /home/alniger/netology.devops/04-script-02-py/README.md
Modified: /home/alniger/netology.devops/04-script-02-py/test1.py
Modified: /home/alniger/netology.devops/04-script-02-py/test2.py
alniger@HP:~/netology.devops/04-script-02-py$ 

```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import socket

socket_url = ['drive.google.com','mail.google.com','google.com']
array_0 = []
array_1 = []

with open('ip.log','r') as inp:
    array_1 = inp.read().split(',') #Формирование массива из файла
    inp.close()
count=0
for socket_ip in socket_url:
    array_0.append(socket.gethostbyname(socket_ip)) #Формирования массива фактического
    if socket.gethostbyname(socket_ip) == array_1[count]:
        print(socket_ip,socket.gethostbyname(socket_ip)) 
    else:
        print('ERROR:',socket_ip,'IP mismatch:',array_1[count],socket.gethostbyname(socket_ip))
    count+=1

with open('ip.log','w+') as inp2:
    inp2.write(','.join(array_0))
    inp2.close()
```

### Вывод скрипта при запуске при тестировании:
```
alniger@HP:~/netology.devops/04-script-02-py$ ./test5.py
ERROR: drive.google.com IP mismatch: 64.233.164.194 74.125.131.194
mail.google.com 142.251.1.83
google.com 173.194.220.101
alniger@HP:~/netology.devops/04-script-02-py$ ./test5.py
drive.google.com 74.125.131.194
mail.google.com 142.251.1.83
google.com 173.194.220.101
alniger@HP:~/netology.devops/04-script-02-py$ ./test5.py
drive.google.com 74.125.131.194
mail.google.com 142.251.1.83
ERROR: google.com IP mismatch: 173.194.220.101 173.194.220.113
```

```

```
