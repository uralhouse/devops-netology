# Решение домашнего задания к занятию "6.3. MySQL"



## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

​		Подготавливаем файл docker-compose.yml

```
version: '3.1'
services:
  db:
    image: mysql
    container_name: db
    environment:
      MYSQL_ROOT_PASSWORD: 12345
    ports:
      - "3306:3306"
    volumes:
      - dbdata:/var/lib/mysql
volumes:
  dbdata:
```

​		Запускаем docker-compose up и проверяем запущенный контейнер:

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.3$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                                                                    NAMES
ea5e5a70629c   mysql     "docker-entrypoint.s…"   13 minutes ago   Up 12 minutes   0.0.0.0:3306->3306/tcp, :::3306->3                                  306/tcp, 33060/tcp   db
```

​		Заходим в контейнер MySQL и проверяем работоспособность командами:

```
uralhouse@DELL:/var/tmp$ docker exec -it ea5e5a70629c bash
root@ea5e5a70629c:/var/lib/mysql# mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 15
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          15
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.28 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 26 min 27 sec

Threads: 2  Questions: 54  Slow queries: 0  Opens: 155  Flush tables: 3  Open tables: 73  Queries per second avg: 0.034
--------------
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и восстановитесь из него.

​		Скачиваем бэкап БД, копируем файл в контейнер и восстанавливаем бэкап в MySQL

```
uralhouse@DELL:~/netology.devops/BD/lesson_6.3$ wget https://raw.githubusercontent.com/netology-code/virt-homeworks/master/06-db-03-mysql/test_data/test_dump.sql
```

​		Копируем файл в контейнер:

```		
uralhouse@DELL:~/netology.devops/BD/lesson_6.3$ docker cp test_dump.sql ea5e5a70629c:/var/lib/mysql/test_dump.sql
```

​		Восстанавливаем бэкап в MySQL

```
root@ea5e5a70629c:/var/lib/mysql# mysql -uroot -p
Enter password:

mysql> CREATE DATABASE backup_db;
Query OK, 1 row affected (0.05 sec)

mysql> exit
Bye

root@ea5e5a70629c:/var/lib/mysql# mysql -uroot -p backup_db < /var/lib//mysql/test_dump.sql

root@ea5e5a70629c:/var/lib/mysql# mysql -uroot -p
Enter password:

mysql> USE backup_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+---------------------+
| Tables_in_backup_db |
+---------------------+
| orders              |
+---------------------+
1 row in set (0.01 sec)
```

Перейдите в управляющую консоль `mysql` внутри контейнера.

```
uralhouse@DELL:/var/tmp$ docker exec -it ea5e5a70629c bash
root@ea5e5a70629c:/var/lib/mysql# mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 15
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```

Используя команду `\h` получите список управляющих команд.

```
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.

For server side help, type 'help contents'
```

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

```
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          15
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.28 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 26 min 27 sec

Threads: 2  Questions: 54  Slow queries: 0  Opens: 155  Flush tables: 3  Open tables: 73  Queries per second avg: 0.034
--------------
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

```
mysql> USE backup_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+---------------------+
| Tables_in_backup_db |
+---------------------+
| orders              |
+---------------------+
1 row in set (0.01 sec)
```

**Приведите в ответе** количество записей с `price` > 300.

```
mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)


```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

```
mysql> CREATE USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3
    -> ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
No connection. Trying to reconnect...
Enter password:
Connection id:    17
Current database: backup_db

Query OK, 0 rows affected (0.03 sec)
```

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

```    
mysql> GRANT SELECT ON backup_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.02 sec)
```

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
приведите в ответе к задаче.

```
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.01 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

   Это журнал запросов за сессию с временем выполнения + подробный вывод по каждому запросу (прим.7)

```
mysql> SHOW PROFILES;
+----------+------------+-----------------------------+
| Query_ID | Duration   | Query                       |
+----------+------------+-----------------------------+
|        1 | 0.00044850 | SET profiling=1             |
|        2 | 0.00047625 | SET profiling=1             |
|        3 | 0.00027600 | HOW PROFILES                |
|        4 | 0.00044550 | SET profiling=1             |
|        5 | 0.00044650 | set profiling=1             |
|        6 | 0.00039000 | set profiling=1             |
|        7 | 0.05038300 | SELECT COUNT(*) FROM orders |
+----------+------------+-----------------------------+
7 rows in set, 1 warning (0.00 sec)

mysql> show profile for query 7;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000129 |
| Executing hook on transaction  | 0.000033 |
| starting                       | 0.000036 |
| checking permissions           | 0.000035 |
| Opening tables                 | 0.000085 |
| init                           | 0.000035 |
| System lock                    | 0.000116 |
| optimizing                     | 0.000033 |
| statistics                     | 0.000043 |
| preparing                      | 0.000054 |
| executing                      | 0.044890 |
| end                            | 0.000040 |
| query end                      | 0.000042 |
| waiting for handler commit     | 0.000090 |
| closing tables                 | 0.000036 |
| freeing items                  | 0.004560 |
| cleaning up                    | 0.000127 |
+--------------------------------+----------+
17 rows in set, 1 warning (0.01 sec)

mysql>
```

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```
mysql> SELECT ENGINE, TABLE_NAME FROM information_schema.tables WHERE TABLE_NAME='orders';
+--------+------------+
| ENGINE | TABLE_NAME |
+--------+------------+
| InnoDB | orders     |
+--------+------------+
1 row in set (0.01 sec)
```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

```
mysql> ALTER TABLE orders ENGINE=MyISAM;
Query OK, 5 rows affected (0.23 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                              |
+----------+------------+------------------------------------------------------------------------------------+
|        1 | 0.00044850 | SET profiling=1                                                                    |
|        2 | 0.00047625 | SET profiling=1                                                                    |
|        3 | 0.00027600 | HOW PROFILES                                                                       |
|        4 | 0.00044550 | SET profiling=1                                                                    |
|        5 | 0.00044650 | set profiling=1                                                                    |
|        6 | 0.00039000 | set profiling=1                                                                    |
|        7 | 0.05038300 | SELECT COUNT(*) FROM orders                                                        |
|        8 | 0.01706825 | SELECT ENGINE, TABLE_NAME FROM information_schema.tables WHERE TABLE_NAME='orders' |
|        9 | 0.34946800 | ALTER TABLE orders ENGINE=InnoDB                                                   |
|       10 | 0.24397200 | ALTER TABLE orders ENGINE=MyISAM                                                   |
+----------+------------+------------------------------------------------------------------------------------+
10 rows in set, 1 warning (0.00 sec)

mysql> ALTER TABLE orders ENGINE=InnoDB;
Query OK, 5 rows affected (0.25 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                              |
+----------+------------+------------------------------------------------------------------------------------+
|        1 | 0.00044850 | SET profiling=1                                                                    |
|        2 | 0.00047625 | SET profiling=1                                                                    |
|        3 | 0.00027600 | HOW PROFILES                                                                       |
|        4 | 0.00044550 | SET profiling=1                                                                    |
|        5 | 0.00044650 | set profiling=1                                                                    |
|        6 | 0.00039000 | set profiling=1                                                                    |
|        7 | 0.05038300 | SELECT COUNT(*) FROM orders                                                        |
|        8 | 0.01706825 | SELECT ENGINE, TABLE_NAME FROM information_schema.tables WHERE TABLE_NAME='orders' |
|        9 | 0.34946800 | ALTER TABLE orders ENGINE=InnoDB                                                   |
|       10 | 0.24397200 | ALTER TABLE orders ENGINE=MyISAM                                                   |
|       11 | 0.25533050 | ALTER TABLE orders ENGINE=InnoDB                                                   |
+----------+------------+------------------------------------------------------------------------------------+
11 rows in set, 1 warning (0.00 sec)

```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

```
root@ea5e5a70629c:/etc# nano /etc/mysql/my.cnf

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/
#Skorost' IO vazhnee sohrannosti dannyh
innodb_flush_log_at_trx_commit = 2
#Nuzhna kompressiya tablic dlya ekonomii mesta na diske
innodb_file_per_table = 1
#Razmer buffera s nezakomichennymi tranzakciyami 1 Mb
innodb_log_buffer_size = 1M
#Buffer keshirovaniya 30% ot OZU
innodb_buffer_pool_size = 1200M
#Razmer fajla logov operacij 100 Mb
innodb_log_file_size = 100M
```

---

