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

   Выполнение playbook:

   ```
   ~/netology/devops-netology/3_mnt-homeworks/08-ansible-03-role/playbook$ ansible-playbook -i inventory/prod.yml site.yml
   
   PLAY [Install nginx, clickhouse, lighthouse, vector] ****************************************************************************************************************
   
   TASK [Gathering Facts] **********************************************************************************************************************************************
   ok: [centos]
   
   TASK [nginx : Include OS-specific variables.] ***********************************************************************************************************************
   ok: [centos]
   
   TASK [nginx : Define nginx_user.] ***********************************************************************************************************************************
   ok: [centos]
   
   TASK [nginx : include_tasks] ****************************************************************************************************************************************
   included: /home/uralhouse/netology/devops-netology/3_mnt-homeworks/08-ansible-03-role/playbook/roles/nginx/tasks/setup-RedHat.yml for centos
   
   TASK [nginx : Enable nginx repo.] ***********************************************************************************************************************************
   ok: [centos]
   
   TASK [nginx : Ensure nginx is installed.] ***************************************************************************************************************************
   ok: [centos]
   
   TASK [nginx : include_tasks] ****************************************************************************************************************************************
   skipping: [centos]
   
   TASK [nginx : include_tasks] ****************************************************************************************************************************************
   skipping: [centos]
   
   TASK [nginx : include_tasks] ****************************************************************************************************************************************
   skipping: [centos]
   
   TASK [nginx : include_tasks] ****************************************************************************************************************************************
   skipping: [centos]
   
   TASK [nginx : include_tasks] ****************************************************************************************************************************************
   skipping: [centos]
   
   TASK [nginx : Remove default nginx vhost config file (if configured).] **********************************************************************************************
   skipping: [centos]
   
   TASK [nginx : Ensure nginx_vhost_path exists.] **********************************************************************************************************************
   ok: [centos]
   
   TASK [nginx : Add managed vhost config files.] **********************************************************************************************************************
   
   TASK [nginx : Remove managed vhost config files.] *******************************************************************************************************************
   
   TASK [nginx : Remove legacy vhosts.conf file.] **********************************************************************************************************************
   ok: [centos]
   
   TASK [nginx : Copy nginx configuration in place.] *******************************************************************************************************************
   ok: [centos]
   
   TASK [nginx : Ensure nginx service is running as configured.] *******************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Include OS Family Specific Variables] ************************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : include_tasks] ***********************************************************************************************************************************
   included: /home/uralhouse/netology/devops-netology/3_mnt-homeworks/08-ansible-03-role/playbook/roles/clickhouse/tasks/precheck.yml for centos
   
   TASK [clickhouse : Requirements check | Checking sse4_2 support] ****************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Requirements check | Not supported distribution && release] **************************************************************************************
   skipping: [centos]
   
   TASK [clickhouse : include_tasks] ***********************************************************************************************************************************
   included: /home/uralhouse/netology/devops-netology/3_mnt-homeworks/08-ansible-03-role/playbook/roles/clickhouse/tasks/params.yml for centos
   
   TASK [clickhouse : Set clickhouse_service_enable] *******************************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Set clickhouse_service_ensure] *******************************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : include_tasks] ***********************************************************************************************************************************
   included: /home/uralhouse/netology/devops-netology/3_mnt-homeworks/08-ansible-03-role/playbook/roles/clickhouse/tasks/install/yum.yml for centos
   
   TASK [clickhouse : Install by YUM | Ensure clickhouse repo GPG key imported] ****************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Install by YUM | Ensure clickhouse repo installed] ***********************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] ***********************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (version latest)] ***************************************************************************
   skipping: [centos]
   
   TASK [clickhouse : include_tasks] ***********************************************************************************************************************************
   included: /home/uralhouse/netology/devops-netology/3_mnt-homeworks/08-ansible-03-role/playbook/roles/clickhouse/tasks/configure/sys.yml for centos
   
   TASK [clickhouse : Check clickhouse config, data and logs] **********************************************************************************************************
   ok: [centos] => (item=/var/log/clickhouse-server)
   ok: [centos] => (item=/etc/clickhouse-server)
   ok: [centos] => (item=/var/lib/clickhouse/tmp/)
   ok: [centos] => (item=/var/lib/clickhouse/)
   
   TASK [clickhouse : Config | Create config.d folder] *****************************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Config | Create users.d folder] ******************************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Config | Generate system config] *****************************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Config | Generate users config] ******************************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Config | Generate remote_servers config] *********************************************************************************************************
   skipping: [centos]
   
   TASK [clickhouse : Config | Generate macros config] *****************************************************************************************************************
   skipping: [centos]
   
   TASK [clickhouse : Config | Generate zookeeper servers config] ******************************************************************************************************
   skipping: [centos]
   
   TASK [clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] **************************************************************************
   skipping: [centos]
   
   TASK [clickhouse : include_tasks] ***********************************************************************************************************************************
   included: /home/uralhouse/netology/devops-netology/3_mnt-homeworks/08-ansible-03-role/playbook/roles/clickhouse/tasks/service.yml for centos
   
   TASK [clickhouse : Ensure clickhouse-server.service is enabled: True and state: started] ****************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Wait for Clickhouse Server to Become Ready] ******************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : include_tasks] ***********************************************************************************************************************************
   included: /home/uralhouse/netology/devops-netology/3_mnt-homeworks/08-ansible-03-role/playbook/roles/clickhouse/tasks/configure/db.yml for centos
   
   TASK [clickhouse : Set ClickHose Connection String] *****************************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Gather list of existing databases] ***************************************************************************************************************
   ok: [centos]
   
   TASK [clickhouse : Config | Delete database config] *****************************************************************************************************************
   
   TASK [clickhouse : Config | Create database config] *****************************************************************************************************************
   
   TASK [clickhouse : include_tasks] ***********************************************************************************************************************************
   included: /home/uralhouse/netology/devops-netology/3_mnt-homeworks/08-ansible-03-role/playbook/roles/clickhouse/tasks/configure/dict.yml for centos
   
   TASK [clickhouse : Config | Generate dictionary config] *************************************************************************************************************
   skipping: [centos]
   
   TASK [clickhouse : include_tasks] ***********************************************************************************************************************************
   skipping: [centos]
   
   TASK [lighthouse : Installing git] **********************************************************************************************************************************
   ok: [centos]
   
   TASK [lighthouse : Copy Lighthouse to folder] ***********************************************************************************************************************
   ok: [centos]
   
   TASK [vector : Create vector_home dir] ******************************************************************************************************************************
   ok: [centos]
   
   TASK [vector : Get vector distrib] **********************************************************************************************************************************
   ok: [centos]
   
   TASK [vector : Create folder for unit-file] *************************************************************************************************************************
   ok: [centos]
   
   TASK [vector : Create vector.service-file from template] ************************************************************************************************************
   ok: [centos]
   
   TASK [vector : Install vector packages] *****************************************************************************************************************************
   ok: [centos]
   
   TASK [Create nginx config] ******************************************************************************************************************************************
   ok: [centos]
   
   TASK [Copy clickhouse to www] ***************************************************************************************************************************************
   changed: [centos]
   
   PLAY RECAP **********************************************************************************************************************************************************
   centos                     : ok=42   changed=1    unreachable=0    failed=0    skipped=18   rescued=0    ignored=0
   ```

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
