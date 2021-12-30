# Решение домашнее задания к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

```json
  { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : 71.78.22.43
            }
        ]
    }
```



## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import socket
import json
import yaml

socket_url = ['drive.google.com','mail.google.com','google.com']
array_0 = []
array_1 = []
array_2 = {}

with open('ip.log','r') as inp:
    array_1 = inp.read().split(',') #Формирование массива из файла
    inp.close()
count=0
for socket_ip in socket_url:
    array_0.append(socket.gethostbyname(socket_ip)) #Формирования массива фактического
    array_2[socket_ip] = socket.gethostbyname(socket_ip)
    if socket.gethostbyname(socket_ip) == array_1[count]:
        print(socket_ip,socket.gethostbyname(socket_ip))  
    else:
        print('ERROR:',socket_ip,'IP mismatch:',array_1[count],socket.gethostbyname(socket_ip))
    count+=1

with open('ip.log','w+') as inp2:
    inp2.write(','.join(array_0))
    inp2.close()

with open ('ip.yml', 'w+') as yml1:
    yml1.write(yaml.dump(array_2, indent = 2, explicit_start = True, explicit_end = True))
with open ('ip.json', 'w+') as js1:
    js1.write(json.dumps(array_2))
```

### Вывод скрипта при запуске при тестировании:
```
alniger@HP:~/netology.devops/04-script-03-yaml$ ./test.py
ERROR: drive.google.com IP mismatch: 108.177.14.194 64.233.164.194
mail.google.com 216.58.209.197
google.com 216.58.210.142
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"drive.google.com": "64.233.164.194", "mail.google.com": "216.58.209.197", "google.com": "216.58.210.142"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
drive.google.com: 64.233.164.194
google.com: 216.58.210.142
mail.google.com: 216.58.209.197
...
```

