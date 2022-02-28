# Решение домашнего задания к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

Подготавливаем файл docker-compose.yml

```
version: '3.8'
services:
  db:
    image: postgres:12-alpine
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - '5432:5432'
    volumes:
      - db:/var/lib/postgresql/data
      - backup:/var/tmp
volumes:
  db:
    driver: local
  backup:
```

Запускаем docker-compose up и проверяем запущенный контейнер:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.2$ docker-compose ps
     Name                   Command              State                    Ports
-------------------------------------------------------------------------------------------------
lesson_62_db_1   docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp,:::5432->5432/tcp
```

Заходим в контейнер и PostgreSQL:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.2$ docker exec -it lesson_62_db_1 /bin/sh
/ # su - postgres
60073ca2cb6a:~$ psql
psql (12.10)
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres

```



## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db

  ```
  CREATE DATABASE test_db;
  CREATE USER test_admin_user WITH PASSWORD '1234567890';

- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)

  ```
  CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  наименование TEXT,
  цена INT
  );
  
  CREATE TABLE clients (
      id SERIAL PRIMARY KEY,
      фамилия TEXT,
      страна_проживания TEXT,
      заказ INT,
      FOREIGN KEY (заказ) REFERENCES orders (id)
  );

- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db

  ```
  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO test_admin_user;

- создайте пользователя test-simple-user  

  ```
  CREATE USER test_simple_user WITH PASSWORD '0987654321';

- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

  ```
  GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO test_simple_user;

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,

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
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```

- описание таблиц (describe)

  ```
  
  test_db-# \d orders
                                 Table "public.orders"
      Column    |  Type   | Collation | Nullable |              Default
  --------------+---------+-----------+----------+------------------------------------
   id           | integer |           | not null | nextval('orders_id_seq'::regclass)
   наименование | text    |           |          |
   цена         | integer |           |          |
  Indexes:
      "orders_pkey" PRIMARY KEY, btree (id)
  Referenced by:
      TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
  
  test_db-# \d clients
                                    Table "public.clients"
        Column       |  Type   | Collation | Nullable |               Default
  -------------------+---------+-----------+----------+-------------------------------------
   id                | integer |           | not null | nextval('clients_id_seq'::regclass)
   фамилия           | text    |           |          |
   страна_проживания | text    |           |          |
   заказ             | integer |           |          |
  Indexes:
      "clients_pkey" PRIMARY KEY, btree (id)
  Foreign-key constraints:
      "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
  
  test_db-#
  ```

  

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

- список пользователей с правами над таблицами test_db

  ```
  test_db=# SELECT * from information_schema.table_privileges WHERE grantee LIKE 'test%';
   grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
  ----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
   postgres | test_admin_user  | test_db       | public       | orders     | INSERT         | NO           | NO
   postgres | test_admin_user  | test_db       | public       | orders     | SELECT         | NO           | YES
   postgres | test_admin_user  | test_db       | public       | orders     | UPDATE         | NO           | NO
   postgres | test_admin_user  | test_db       | public       | orders     | DELETE         | NO           | NO
   postgres | test_admin_user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
   postgres | test_admin_user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
   postgres | test_admin_user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
   postgres | test_admin_user  | test_db       | public       | clients    | INSERT         | NO           | NO
   postgres | test_admin_user  | test_db       | public       | clients    | SELECT         | NO           | YES
   postgres | test_admin_user  | test_db       | public       | clients    | UPDATE         | NO           | NO
   postgres | test_admin_user  | test_db       | public       | clients    | DELETE         | NO           | NO
   postgres | test_admin_user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
   postgres | test_admin_user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
   postgres | test_admin_user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
   postgres | test_simple_user | test_db       | public       | orders     | INSERT         | NO           | NO
   postgres | test_simple_user | test_db       | public       | orders     | SELECT         | NO           | YES
   postgres | test_simple_user | test_db       | public       | orders     | UPDATE         | NO           | NO
   postgres | test_simple_user | test_db       | public       | orders     | DELETE         | NO           | NO
   postgres | test_simple_user | test_db       | public       | clients    | INSERT         | NO           | NO
   postgres | test_simple_user | test_db       | public       | clients    | SELECT         | NO           | YES
   postgres | test_simple_user | test_db       | public       | clients    | UPDATE         | NO           | NO
   postgres | test_simple_user | test_db       | public       | clients    | DELETE         | NO           | NO
  (22 rows)

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

```
INSERT INTO orders (наименование, цена)
  VALUES
  ('Шоколад', 10),
  ('Принтер', 3000),
  ('Книга',   500),
  ('Монитор', 7000),
  ('Гитара',  4000);
```



Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

```
INSERT INTO clients (фамилия, страна_проживания)
  VALUES
  ('Иванов Иван Иванович', 'USA'),
  ('Петров Петр Петрович', 'Canada'),
  ('Иоганн Себастьян Бах', 'Japan'),
  ('Ронни Джеймс Дио', 'Russia'),
  ('Ritchie Blackmore', 'Russia');
```



Используя SQL синтаксис:

- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

```
test_db=# SELECT COUNT(*) FROM orders;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT(*) FROM clients;
 count
-------
     5
(1 row)

test_db=#

```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

```
test_db=# UPDATE clients SET заказ=3 WHERE id=1;
UPDATE 1
test_db=# UPDATE clients SET заказ=4 WHERE id=2;
UPDATE 1
test_db=#
test_db=# UPDATE clients SET заказ=5 WHERE id=3;
UPDATE 1
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```
test_db=# SELECT * FROM clients WHERE заказ IS NOT NULL;
 id |       фамилия        | страна_проживания | заказ
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)
```



## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```
test_db=# EXPLAIN SELECT * FROM clients WHERE заказ IS NOT NULL;
                        QUERY PLAN
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("заказ" IS NOT NULL)
(2 rows)
```

Оценка стоимости выполнения данного плана.

-  (0.00) Приблизительная стоимость запуска. Это время, которое проходит, прежде чем начнётся этап вывода данных, например для сортирующего узла это время сортировки.
- (18.10)Приблизительная общая стоимость. Она вычисляется в предположении, что узел плана выполняется до конца, то есть возвращает все доступные строки. На практике родительский узел может досрочно прекратить чтение строк дочернего (см. приведённый ниже пример с `LIMIT`).
- (806) Ожидаемое число строк, которое должен вывести этот узел плана. При этом так же предполагается, что узел выполняется до конца.
- (72) Ожидаемый средний размер строк, выводимых этим узлом плана (в байтах).

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).			

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.2$ docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED        STATUS        PORTS                                       NAMES
60073ca2cb6a   postgres:12-alpine   "docker-entrypoint.s…"   16 hours ago   Up 16 hours   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   lesson_62_db_1
uralhouse@DELL:~/netology.devops/BD/lesson_6.2$ docker exec -it 60073ca2cb6a /bin/sh
/ # su - postgres
60073ca2cb6a:~$ pg_dump -U postgres -p 5432 --format=custom test_db -f /var/tmp/test_db.backup
```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.2$ docker stop 60073ca2cb6a
60073ca2cb6a
uralhouse@DELL:~/netology.devops/BD/lesson_6.2$ docker volume ls
DRIVER    VOLUME NAME
local     abb65a43b425d92bb73f4520a9b42ba5f3c10310a8b9d8093085030fe91eb034
local     lesson_62_backup
local     lesson_62_db
local     lesson_62_postgres
```

Поднимите новый пустой контейнер с PostgreSQL.

​		Правим файл docker-compose.yml

```
version: '3.8'
services:
  db:
    image: postgres:12-alpine
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - '5432:5432'
    volumes:
      - backup:/var/tmp
volumes:
  backup:
```

​	Запускаем docker-compose up и проверяем запущенный контейнер:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.2$ docker-compose up
uralhouse@DELL:~/netology.devops/BD/lesson_6.2$ docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED          STATUS          PORTS                                       NAMES
893d6f8472f1   postgres:12-alpine   "docker-entrypoint.s…"   13 minutes ago   Up 13 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   lesson_62_db_1
```

​		Заходим в новый PostgreSQL:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.2$ docker exec -it 893d6f8472f1 /bin/sh
/ # su - postgres
893d6f8472f1:~$ sql
-sh: sql: not found
893d6f8472f1:~$ psql
psql (12.10)
Type "help" for help.

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

postgres=# quit
```



Восстановите БД test_db в новом контейнере.

​			Добавляем пользователей:

```
postgres=# CREATE USER test_admin_user WITH PASSWORD '1234567890';
CREATE ROLE
postgres=# CREATE USER test_simple_user WITH PASSWORD '0987654321';
CREATE ROLE
```

​			Используем утилиту pg_restore предназначенная для восстановления базы данных PostgreSQL из архива, созданного командой pg_dump и восстанавливаем базу test_db в PostgreSQL:

```
893d6f8472f1:~$ pg_restore --create --file=/var/tmp/pg_restore.script /var/tmp/test_db.backup
893d6f8472f1:~$ ls /var/tmp/
pg_restore.script  test_db.backup
893d6f8472f1:~$ psql -f /var/tmp/pg_restore.script
```

​			Проверяем нашу восстановленную базу test_db:

``` 	
893d6f8472f1:~$ psql
psql (12.10)
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

postgres=#
postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db=# SELECT * FROM orders;
 id | наименование | цена
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)

test_db=# SELECT * FROM clients;
 id |       фамилия        | страна_проживания | заказ
----+----------------------+-------------------+-------
  4 | Ронни Джеймс Дио     | Russia            |
  5 | Ritchie Blackmore    | Russia            |
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(5 rows)

test_db=#
```



