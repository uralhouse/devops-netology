# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.



Подготавливаем файл Dockerfile манифеста:

```
FROM centos:centos7

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN yum makecache && \
    yum -y install wget \
    yum -y install perl-Digest-SHA

RUN \
  cd / && \
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz && \
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512 && \
  shasum -a 512 -c elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512 && \
  tar -xzf elasticsearch-7.17.0-linux-x86_64.tar.gz && \
  rm -f *.tar.gz && \
  mv /elasticsearch-7.17.0 /elasticsearch

RUN mkdir /var/lib/logs /var/lib/data

COPY elasticsearch.yml /elasticsearch/config

RUN chmod -R 777 /elasticsearch && \
    chmod -R 777 /var/lib/logs && \
    chmod -R 777 /var/lib/data

USER elasticsearch

VOLUME /var/lib/data

EXPOSE 9200
EXPOSE 9300

WORKDIR /elasticsearch/bin/

ENTRYPOINT ./elasticsearch
```



Подготовлен файл [elasticsearch.yml](elasticsearch.yml).

Запускаем сборку, размещаем в репозитории dockerhub и запускаем образ:

``` 
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ docker build -t centos7-elasticsearch7_17_0 .
Successfully built 9f5f7b64dd00
Successfully tagged centos7-elasticsearch7_17_0:latest

uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ docker login
Login Succeeded

uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ docker tag centos7-elasticsearch7_17_0 uralhouse/elasticsearch:1      uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ docker push uralhouse/elasticsearch:1
The push refers to repository [docker.io/uralhouse/elasticsearch]
dbe4711a25bc: Pushed
4281a71035a0: Pushed
86bd01930aa5: Pushed
d447a7d04417: Pushed
e245ae828103: Pushed
4d93ab95f4c3: Pushed
174f56854903: Mounted from library/centos
1: digest: sha256:3aa50b512f08a2a92afe220cebb0beb05a93f8726fbb7dd7ee82f3cc74f4fd18 size: 1791

```

Cсылка на образ в репозитории dockerhub: https://hub.docker.com/r/uralhouse/elasticsearch/tags

Pull command: docker pull uralhouse/elasticsearch:1

Запускаем контейнер:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ docker image ls
REPOSITORY                    TAG       IMAGE ID       CREATED          SIZE
centos7-elasticsearch7_17_0   latest    9f5f7b64dd00   14 minutes ago   1.62GB
uralhouse/elasticsearch       1         9f5f7b64dd00   14 minutes ago   1.62GB
centos                        centos7   eeb6ee3f44bd   5 months ago     204MB
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ docker run -p=9200:9200 -p=9300:9300 centos7-elasticsearch7_17_0
```



Ответ `elasticsearch` на запрос пути `/` в json виде:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X GET http://localhost:9200
{
  "name" : "c6be84c30616",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "4Wqe7YoxTyqoRHj49yNQ-g",
  "version" : {
    "number" : "7.17.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "bee86328705acaa9a6daede7140defd4d9ec56bd",
    "build_date" : "2022-01-28T08:36:04.875279988Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```



## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

​	Создаем индексы и получам их статусы:

```
curl -X PUT http://localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0,  "number_of_shards": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}

curl -X PUT http://localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 1,  "number_of_shards": 2 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}

curl -X PUT http://localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 2,  "number_of_shards": 4 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}
```



Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

​			Получаем список индексов:				

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases ZFit-aN7SxyxMCWYTgTKDg   1   0         45            0     42.5mb         42.5mb
green  open   ind-1            GZHoUtv0R3uLV-s6t9nveA   1   0          0            0       226b           226b
yellow open   ind-3            WQjbn33LQ7qOwN1324Iecg   4   2          0            0       904b           904b
yellow open   ind-2            H51jvfFHTgujhD7VzuYYPA   2   1          0            0       452b           452b
```

​		Получаем статусы:

```

uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```

Получите состояние кластера `elasticsearch`, используя API.

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X GET 'http://localhost:9200/_cluster/health/?pretty=true'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```



Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

​			Индексы ind-3 и ind-2 имеют статус "yellow", потому что указано число реплик, а так как один сервер и поэтому реплицировать некуда.

Удалите все индексы.

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
```



**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

​			Регистрируем через API директорию netology_backup:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X POST http://localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/elasticsearch/snapshots" }}'
{
  "acknowledged" : true
}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

​				Создаем индекс:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X PUT http://localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0, "number_of_shards": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

​		Создаем snapshot:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X PUT http://localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","uuid":"7Qe99ZL_TcmtzMIpVUD8zA","repository":"netology_backup","version_id":7170099,"version":"7.17.0","indices":[".ds-ilm-history-5-2022.03.10-000001",".geoip_databases","test",".ds-.logs-deprecation.elasticsearch-default-2022.03.10-000001"],"data_streams":["ilm-history-5",".logs-deprecation.elasticsearch-default"],"include_global_state":true,"state":"SUCCESS","start_time":"2022-03-10T10:16:04.924Z","start_time_in_millis":1646907364924,"end_time":"2022-03-10T10:16:06.934Z","end_time_in_millis":1646907366934,"duration_in_millis":2010,"failures":[],"shards":{"total":4,"failed":0,"successful":4},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}
```

​			Выводим список файлов snapshot:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ docker ps
CONTAINER ID   IMAGE                         COMMAND                  CREATED          STATUS          PORTS                                                                                  NAMES
c6be84c30616   centos7-elasticsearch7_17_0   "/bin/sh -c ./elasti…"   37 minutes ago   Up 37 minutes   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   youthful_austin

uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ docker exec -it c6be84c30616 bash

[elasticsearch@c6be84c30616 snapshots]$ cd /elasticsearch/snapshots/
[elasticsearch@c6be84c30616 snapshots]$ ll
total 48
-rw-r--r-- 1 elasticsearch elasticsearch  1425 Mar 10 10:16 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Mar 10 10:16 index.latest
drwxr-xr-x 6 elasticsearch elasticsearch  4096 Mar 10 10:16 indices
-rw-r--r-- 1 elasticsearch elasticsearch 29286 Mar 10 10:16 meta-7Qe99ZL_TcmtzMIpVUD8zA.dat
-rw-r--r-- 1 elasticsearch elasticsearch   712 Mar 10 10:16 snap-7Qe99ZL_TcmtzMIpVUD8zA.dat

```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

​			Удаляем индекс test:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}
```

​			Создаем индекс test-2:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X PUT http://localhost:9200/test-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0, "number_of_shards": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"}
```

​			Список индексов:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases ZFit-aN7SxyxMCWYTgTKDg   1   0         45            0     42.5mb         42.5mb
green  open   test-2           N-4L9_HLRUurvDqlXQqQ2w   1   0          0            0       226b           226b
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

​			Восстанавливаем состояние кластера и получаем список индексов:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X POST "localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty" -H 'Content-Type: application/json' -d'
> {
>   "indices": "test"
> }
> '
{
  "accepted" : true
}

uralhouse@DELL:~/netology.devops/BD/lesson_6.5$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases ZFit-aN7SxyxMCWYTgTKDg   1   0         45            0     42.5mb         42.5mb
green  open   test-2           N-4L9_HLRUurvDqlXQqQ2w   1   0          0            0       226b           226b
green  open   test             9kxOOPpFS8-4QCoem1d-5A   1   0          0            0       226b           226b
```



