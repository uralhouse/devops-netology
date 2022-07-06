# Решение домашнего задания к занятию "8.4 Работа с Roles"

## Подготовка к выполнению
1. (Необязательно) Познакомтесь с [lighthouse](https://youtu.be/ymlrNlaHzIY?t=929)

2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.

   Созданы два пустых репозитория:

   [https://github.com/uralhouse/vector-role](https://github.com/uralhouse/vector-role)

   [https://github.com/uralhouse/lighthouse-role](https://github.com/uralhouse/lighthouse-role)

3. Добавьте публичную часть своего ключа к своему профилю в github.

   Ключи внесены.

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

   Выполнено. 

   ```
   ~/netology/devops-netology/3.Mnt-homeworks/08-ansible-03-role$ cat requirements.yml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse

2. При помощи `ansible-galaxy` скачать себе эту роль.

   ```
   ~/netology/devops-netology/3.Mnt-homeworks/08-ansible-03-role$ nano requirements.yml
   ~/netology/devops-netology/3.Mnt-homeworks/08-ansible-03-role$ ansible-galaxy install -r requirements.yml -p roles
   Starting galaxy role install process
   - extracting clickhouse to /home/uralhouse/netology/devops-netology/3.Mnt-homeworks/08-ansible-03-role/roles/clickhouse
   - clickhouse (1.11.0) was installed successfully

3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.

   ```
   ~/netology/devops-netology/3.Mnt-homeworks/08-ansible-03-role/roles$ ansible-galaxy role init vector-role
   - Role vector-role was created successfully

4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 

   Выполнено.

5. Перенести нужные шаблоны конфигов в `templates`.

   Выполнено.

6. Описать в `README.md` обе роли и их параметры.

   Выполнено.

7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.

   ```
   ~/netology/devops-netology/3.Mnt-homeworks/08-ansible-03-role/roles$ ansible-galaxy role init lighthouse-role
   - Role lighthouse-role was created successfully

8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в `requirements.yml` в playbook.

9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.

   Проверка правильности скачивания ролей:

   ```
   ~/netology/devops-netology/3.Mnt-homeworks/08-ansible-03-role/playbook$ ansible-galaxy install -r requirements.yml -p roles
   Starting galaxy role install process
   - extracting clickhouse to /home/uralhouse/netology/devops-netology/3.Mnt-homeworks/08-ansible-03-role/playbook/roles/clickhouse
   - clickhouse (1.11.0) was installed successfully
   - extracting nginx to /home/uralhouse/netology/devops-netology/3.Mnt-homeworks/08-ansible-03-role/playbook/roles/nginx
   - nginx (3.1.1) was installed successfully
   - extracting vector to /home/uralhouse/netology/devops-netology/3.Mnt-homeworks/08-ansible-03-role/playbook/roles/vector
   - vector (0.1.0) was installed successfully
   - extracting lighthouse to /home/uralhouse/netology/devops-netology/3.Mnt-homeworks/08-ansible-03-role/playbook/roles/lighthouse
   - lighthouse (0.1.0) was installed successfully
   

10. Выложите playbook в репозиторий.

    Выполнено.

11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

    Репозитории с ролями:

    [https://github.com/uralhouse/vector-role](https://github.com/uralhouse/vector-role)

    [https://github.com/uralhouse/lighthouse-role](https://github.com/uralhouse/lighthouse-role)

    Репозиторий с playbook:

    [https://github.com/uralhouse/devops-netology/tree/main/3_mnt-homeworks/08-ansible-03-role/playbook](https://github.com/uralhouse/devops-netology/tree/main/3_mnt-homeworks/08-ansible-03-role/playbook)
