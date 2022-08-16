# Курс DevOps-инженер
- [Домашнее задания первого модуля «DevOps и системное администрирование»](1_sysadm-homeworks)
- [Курсовая работа по итогам первого модуля](1_sysadm-homeworks/pcs-devsys-diplom)
- [Домашнее задания второго модуля «Виртуализация, базы данных и Terraform»](2_virt-homeworks)
- [Домашнее задания третьего модуля «CI, мониторинг и управление конфигурациями»](3_mnt-homeworks)
- [Дипломный практикум в YandexCloud](4_devops-diplom-yandexcloud)

## DevOps и системное администрирование (первый модуль) 

- Введение в DevOps
### Системы управления версиями
- Системы контроля версий
- Основы Git
- Ветвления в Git
- Инструменты Git

### Основы системного администрирования Linux
<details>
Узнаете, какие бывают типы операционных систем, какие функции они обеспечивают.
Поймёте, как устроено взаимодействие внутри ОС, как приложения обращаются к системе.
Детально разберёте ОС Linux и принципы работы системного администратора с ней.
Научитесь управлять процессами, потоками, сигналами, хранением данных.
  
Изучите основы работы компьютерных сетей, команды для конфигурации сетевых устройств и служб,
инструменты настройки и диагностики сетей, а также самые распространённые сетевые приложения.
Рассмотрите модель OSI, работу сетей TCP/IP на втором, третьем и четвёртом уровнях. 
Узнаете, как работать с VPN, Firewall, NAT.
</details>

- Работа в терминале (лекция 1)
- Работа в терминале (лекция 2)
- Операционные системы (лекция 1)
- Операционные системы (лекция 2)
- Файловые системы
- Компьютерные сети (лекция 1)
- Компьютерные сети (лекция 2)
- Компьютерные сети (лекция 3)
- Элементы безопасности информационных систем

### Скриптовые языки и языки разметки: Python, Bash, YAML, JSON
- Командная оболочка Bash: практические навыки
- Использование Python для решения типовых DevOps задач
- Языки разметки JSON и YAML
- Дополнительный блок
### Разбор задач модуля
<br />

## Виртуализация, базы данных и Terraform (второй модуль)

### Виртуализация
<details>
Узнаете различия видов виртуализации и контейнеризации. 
Научитесь управлять виртуальными машинами с помощью libvirtd. 
Напишете несколько Dockerfile, которые можно будет использовать в дальнейших проектах как примеры. 
Научитесь запускать несколько контейнеров одновременно и объединять их в виртуальную сеть.
</details>

- Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения
- Применение принципов IaaC в работе с виртуальными машинами
- Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера
- Оркестрация группой Docker контейнеров на примере Docker Compose.
- Оркестрация кластером Docker контейнеров на примере Docker Swarm.

### Администрирование баз данных
<details>
Познакомитесь с решениями для полнотекстового поиска. 
Овладеете навыками установки и настройки кеш-систем.
Научитесь устанавливать и настраивать базы данных для нужд разработки. 
Познакомитесь с технологиями создания отказоустойчивых кластеров 
баз данных и кеш систем при помощи кластеризации и шардинга. 
Научитесь писать простые SQL-запросы и запросы для работы с NoSQL-базами данных.
</details>

- Типы и структура СУБД
- SQL
- MySQL
- PostgreSQL
- Elasticsearch
- Troubleshooting

### Облачная инфраструктура. Terraform.
<details>
Научитесь описывать конфигурацию любых сервисов, имеющих API, в виде кода при помощи Terraform. 
Поймёте, как выстраивать командные процессы работы над инфраструктурой. 
Овладеете навыками написания скриптов на Golang. 
Научитесь писать собственные расширения для Terraform.
</details>

- Инфраструктура как код
- Облачные провайдеры и синтаксис Terraform
- Основы Terraform
- Средства командной работы
- Введение в Golang
- Написание собственных провайдеров для Terraform
- Разбор задач
<br />

## Система управления конфигурациями (третий модуль)
<details>
Научитесь описывать инфраструктуру в виде кода. 
Сможете настроить удалённый сервер и восстановить его конфигурацию в случае необходимости. 
Получите набор готовых шаблонов для решения типовых задач конфигурирования серверов.
</details> 

- Введение в Ansible
- Работа с Playbook
- Работа с Roles
- Создание собственных Modules

### Непрерывная разработка и интеграция
<details>
Подробно разберём все этапы жизни ПО. 
Вы узнаете, как организовать взаимодействие между разработчиками, 
тестировщиками и системными администраторами.
Получите практические навыки работы с Jira, Jenkins, TeamCity и Gitlab CI.
</details>

- Жизненный цикл разработки ПО
- Процессы CI/CD: автоматические и ручное тестирование, сборка и доставка в разные окружения.
- Практическое знакомство с Jenkins
- TeamCity
- Gitlab

### Мониторинг и логи
<details>
Подробно разберётесь, зачем нужен мониторинг и какие параметры нужно контролировать. 
Узнаете, как организовать систему оповещения о различных событиях, чтобы узнавать о сбоях первым, а не от заказчика. 
Научитесь организовывать логирование всех действий приложений и анализировать эти логи. 
Овладеете навыками работы с elasticsearch, Logstash, Kibana и Graylog. 
Научитесь настраивать связку Prometehus + Grafana + Alertmanager. 
Познакомитесь с Zabbix для мониторинга физических и виртуальных машин
</details>

- Зачем и что нужно мониторить
- Системы для мониторинга
- Grafana
- ELK
- Sentry
- Инцидент-менеджмент

### Дипломная работа
- [Дипломный практикум в YandexCloud](4_devops-diplom-yandexcloud)