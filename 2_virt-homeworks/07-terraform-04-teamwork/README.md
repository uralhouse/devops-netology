# Решение домашнего задания к занятию "7.4. Средства командной работы над инфраструктурой."

<details>
<summary> Пропущенное задание</summary>

## Задача 1. Настроить terraform cloud (необязательно, но крайне желательно).

В это задании предлагается познакомиться со средством командой работы над инфраструктурой предоставляемым
разработчиками терраформа. 

1. Зарегистрируйтесь на [https://app.terraform.io/](https://app.terraform.io/).
(регистрация бесплатная и не требует использования платежных инструментов).
1. Создайте в своем github аккаунте (или другом хранилище репозиториев) отдельный репозиторий с
 конфигурационными файлами прошлых занятий (или воспользуйтесь любым простым конфигом).
1. Зарегистрируйте этот репозиторий в [https://app.terraform.io/](https://app.terraform.io/).
1. Выполните plan и apply. 

В качестве результата задания приложите снимок экрана с успешным применением конфигурации.
</details>

## Задача 2. Написать серверный конфиг для атлантиса. 

Смысл задания – познакомиться с документацией о [серверной](https://www.runatlantis.io/docs/server-side-repo-config.html) конфигурации и конфигурации уровня  [репозитория](https://www.runatlantis.io/docs/repo-level-atlantis-yaml.html).

Создай `server.yaml` который скажет атлантису:
1. Укажите, что атлантис должен работать только для репозиториев в вашем github (или любом другом) аккаунте.
1. На стороне клиентского конфига разрешите изменять `workflow`, то есть для каждого репозитория можно 
  будет указать свои дополнительные команды. 
1. В `workflow` используемом по-умолчанию сделайте так, что бы во время планирования не происходил `lock` состояния.

`server.yaml:`

```
repos:
- id: https://github.com/uralhouse/devops-netology/tree/main/2_virt-homeworks/07-terraform-02-syntax/terraform
  apply_requirements: [approved]
  allow_custom_workflows: true
  workflow: default
workflows:
  default:
    plan:
      steps:
      - init
      - plan:
          extra_args: ["-lock", "false"]
    apply:
      steps:
      - apply
```

Создай `atlantis.yaml` который, если поместить в корень terraform проекта, скажет атлантису:
1. Надо запускать планирование и аплай для двух воркспейсов `stage` и `prod`.
1. Необходимо включить автопланирование при изменении любых файлов `*.tf`.

`atlantis.yaml:`

```
version: 3
projects:
- dir: .
  workspace: stage
  autoplan:
    when_modified: ["*.tf", "../modules/**/*.tf"]
    enabled: true
    workflow: default
- dir: .
  workspace: prod
  autoplan:
    when_modified: ["*.tf", "../modules/**/*.tf"]
    enabled: true
    workflow: default
workflows:
  default:
    plan:
      steps:
      - plan:
    apply:
      steps:
      - apply
```

В качестве результата приложите ссылку на файлы `server.yaml` и `atlantis.yaml`.

## Задача 3. Знакомство с каталогом модулей. 

1. В [каталоге модулей](https://registry.terraform.io/browse/modules) найдите официальный модуль от aws для создания
  `ec2` инстансов. 

  [Репозиторий на модуль ec2]([ссылка на гитхаб с нужным модулем](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance))

2. Изучите как устроен модуль. Задумайтесь, будете ли в своем проекте использовать этот модуль или непосредственно 
  ресурс `aws_instance` без помощи модуля?

3. В рамках предпоследнего задания был создан ec2 при помощи ресурса `aws_instance`. 
  Создайте аналогичный инстанс при помощи найденного модуля.   

```
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```



---
