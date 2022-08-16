# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

​		Подготавливаем файл docker-compose.yml

```
version: '3.1'
services:
  db:
    image: postgres:13
    restart: always
    container_name: db
    environment:
      POSTGRES_PASSWORD: 12345
    ports:
      - "5432:5432"
    volumes:
      - dbdata:/var/lib/postgresql/data
volumes:
  dbdata:
```

​		Запускаем docker-compose up и проверяем запущенный контейнер:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.3$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                                                                    NAMES
ea5e5a70629c   mysql     "docker-entrypoint.s…"   13 minutes ago   Up 12 minutes   0.0.0.0:3306->3306/tcp, :::3306->3                                  306/tcp, 33060/tcp   db
```

​		Заходим в контейнер PostgreSQL и проверяем работоспособность командами:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.4$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED              STATUS              PORTS                                       NAMES
cbc29898b1f8   postgres:13   "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   lesson_64_db_1
uralhouse@DELL:~/netology.devops/BD/lesson_6.4$ docker exec -it cbc29898b1f8  bash
root@cbc29898b1f8:/#
```



Подключитесь к БД PostgreSQL используя `psql`.

```
root@cbc29898b1f8:/# psql
psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL:  role "root" does not exist
root@cbc29898b1f8:/# su - postgres
postgres@cbc29898b1f8:~$ psql
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

postgres=#
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД

```
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```

- подключения к БД

```
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo} connect to new database (currently "postgres")

postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
```

- вывода списка таблиц

```
 \dt[S+] [PATTERN]      list tables
 
 postgres=# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
 pg_catalog | pg_amproc               | table | postgres
 pg_catalog | pg_attrdef              | table | postgres
 pg_catalog | pg_attribute            | table | postgres
 pg_catalog | pg_auth_members         | table | postgres
```

- вывода описания содержимого таблиц

```
 \d[S+]                 list tables, views, and sequences
 
postgres=# \d pg_user_mapping
         Table "pg_catalog.pg_user_mapping"
  Column   |  Type  | Collation | Nullable | Default
-----------+--------+-----------+----------+---------
 oid       | oid    |           | not null |
 umuser    | oid    |           | not null |
 umserver  | oid    |           | not null |
 umoptions | text[] | C         |          |
Indexes:
    "pg_user_mapping_oid_index" UNIQUE, btree (oid)
    "pg_user_mapping_user_server_index" UNIQUE, btree (umuser, umserver)
```

- выхода из psql

```
postgres=# \q
postgres@cbc29898b1f8:~$
```

## Задача 2

Используя `psql` создайте БД `test_database`.

```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=#
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.4$ wget https://raw.githubusercontent.com/netology-code/virt-homeworks/master/06-db-04-postgresql/test_data/test_dump.sql
--2022-03-09 08:55:27--  https://raw.githubusercontent.com/netology-code/virt-homeworks/master/06-db-04-postgresql/test_data/test_dump.sql
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.109.133, 185.199.110.133, 185.199.111.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.109.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2082 (2,0K) [text/plain]
Saving to: ‘test_dump.sql’

test_dump.sql                  100%[====================================================>]   2,03K  --.-KB/s    in 0,001s

2022-03-09 08:55:27 (2,98 MB/s) - ‘test_dump.sql’ saved [2082/2082]

uralhouse@DELL:~/netology.devops/BD/lesson_6.4$ nano test_dump.sql
```

Восстановите бэкап БД в `test_database`.

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.4$ docker cp test_dump.sql cbc29898b1f8:/var/tmp/test_dump.sql
uralhouse@DELL:~/netology.devops/BD/lesson_6.4$ docker exec -it cbc29898b1f8  bash
root@cbc29898b1f8:/# su - postgres
postgres@cbc29898b1f8:~$ psql test_database < /var/tmp/test_dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
postgres@cbc29898b1f8:~$
```

Перейдите в управляющую консоль `psql` внутри контейнера.

```
postgres@cbc29898b1f8:~$ psql
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

postgres=#
```

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```
postgres@cbc29898b1f8:~$ psql
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=#
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

```
test_database=# SELECT attname FROM pg_stats WHERE avg_width = (SELECT MAX(avg_width) FROM pg_stats WHERE tablename = 'orders');
 attname
---------
 title
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```
START TRANSACTION;
CREATE TABLE orders_new (LIKE orders INCLUDING DEFAULTS) PARTITION BY RANGE (price);
CREATE TABLE orders_1 PARTITION OF orders_new FOR VALUES FROM (MINVALUE) TO (499);
CREATE TABLE orders_2 PARTITION OF orders_new FOR VALUES FROM (499) TO (MAXVALUE);
INSERT INTO orders_new SELECT * FROM orders;
ALTER TABLE orders RENAME TO orders_old;
ALTER TABLE orders_new RENAME TO orders;
COMMIT;


postgres=# \c test_database
You are now connected to database "test_database4" as user "postgres".
test_database=# START TRANSACTION;
START TRANSACTION
test_database=*# CREATE TABLE orders_new (LIKE orders INCLUDING DEFAULTS) PARTITION BY RANGE (price);
CREATE TABLE
test_database=*# CREATE TABLE orders_1 PARTITION OF orders_new FOR VALUES FROM (MINVALUE) TO (499);
CREATE TABLE
test_database=*# CREATE TABLE orders_2 PARTITION OF orders_new FOR VALUES FROM (499) TO (MAXVALUE);
CREATE TABLE
test_database=*# INSERT INTO orders_new SELECT * FROM orders;
INSERT 0 8
test_database=*# ALTER TABLE orders RENAME TO orders_old;
ALTER TABLE
test_database=*# ALTER TABLE orders_new RENAME TO orders;
ALTER TABLE
test_database=*# COMMIT;
COMMIT
test_database=# SELECT * FROM orders_1;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
(4 rows)

test_database=# SELECT * FROM orders_2;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  7 | Me and my bash-pet |   499
  8 | Dbiezdmin          |   501
(4 rows)

test_database=#
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

​		Можно. При проектировании таблицы необходимо сразу назначать партицированной, тогда нет необходимости переносить данные.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

```
postgres@cbc29898b1f8:~$ pg_dump -U postgres -d test_database >test_database_backup.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

```
ALTER TABLE public.orders_old ADD CONSTRAINT unique_order_title UNIQUE(title);
ALTER TABLE public.orders_1 ADD CONSTRAINT unique_order_1_title UNIQUE(title);
ALTER TABLE public.orders_2 ADD CONSTRAINT unique_order_2_title UNIQUE(title);
```

