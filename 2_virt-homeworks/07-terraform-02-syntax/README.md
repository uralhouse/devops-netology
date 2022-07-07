# Решение домашнего задания к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

<details>
<summary> Пропущенное задание</summary>

## Задача 1 (вариант с AWS). Регистрация в aws и знакомство с основами (необязательно, но крайне желательно).

Остальные задания можно будет выполнять и без этого аккаунта, но с ним можно будет увидеть полный цикл процессов. 

AWS предоставляет достаточно много бесплатных ресурсов в первый год после регистрации, подробно описано [здесь](https://aws.amazon.com/free/).
1. Создайте аккаут aws.
1. Установите c aws-cli https://aws.amazon.com/cli/.
1. Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html.
1. Создайте IAM политику для терраформа c правами
    * AmazonEC2FullAccess
    * AmazonS3FullAccess
    * AmazonDynamoDBFullAccess
    * AmazonRDSFullAccess
    * CloudWatchFullAccess
    * IAMFullAccess
1. Добавьте переменные окружения 
    ```
    export AWS_ACCESS_KEY_ID=(your access key id)
    export AWS_SECRET_ACCESS_KEY=(your secret access key)
    ```
1. Создайте, остановите и удалите ec2 инстанс (любой с пометкой `free tier`) через веб интерфейс. 

В виде результата задания приложите вывод команды `aws configure list`.

</details>

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
    базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

Выполнение команд:

```
~/netology/devops-netology/2_virt-homeworks/07-terraform-02-syntax/terraform$ yc config list
token: AQAAAABctCg0AA**************************
cloud-id: b1ghke5papbqdt8ars**
folder-id: b1gtlsmjgcj4o3fefd**
compute-default-zone: ru-central1-a
uralhouse@hp:~/netology/devops-netology/2_virt-homeworks/07-terraform-02-syntax/terraform$ export TF_VAR_token="AQAAAABctCg0AA**************************"

```

## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.

2. Зарегистрируйте провайдер 
   1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте
   блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион 
   внутри блока `provider`.
   2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти 
   [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).

3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
    их в виде переменных окружения. 

4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  

5. В файле `main.tf` создайте рессурс 
   1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
   Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке 
   `Example Usage`, но желательно, указать большее количество параметров.
   2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).

6. Также в случае использования aws:
   1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
   2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: 
       * AWS account ID,
       * AWS user ID,
       * AWS регион, который используется в данный момент, 
       * Приватный IP ec2 инстансы,
       * Идентификатор подсети в которой создан инстанс.  

7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 

   Выполняем команду `terraform init`:

   ```
   ~/netology/devops-netology/2_virt-homeworks/07-terraform-02-syntax/terraform$ terraform init
   
   Initializing the backend...
   
   Initializing provider plugins...
   - Finding latest version of yandex-cloud/yandex...
   - Installing yandex-cloud/yandex v0.76.0...
   - Installed yandex-cloud/yandex v0.76.0 (self-signed, key ID E40F590B50BB8E40)
   
   Partner and community providers are signed by their developers.
   If you'd like to know more about provider signing, you can read about it here:
   https://www.terraform.io/docs/cli/plugins/signing.html
   
   Terraform has created a lock file .terraform.lock.hcl to record the provider
   selections it made above. Include this file in your version control repository
   so that Terraform can guarantee to make the same selections by default when
   you run "terraform init" in the future.
   
   Terraform has been successfully initialized!
   
   You may now begin working with Terraform. Try running "terraform plan" to see
   any changes that are required for your infrastructure. All Terraform commands
   should now work.
   
   If you ever set or change modules or backend configuration for Terraform,
   rerun this command to reinitialize your working directory. If you forget, other
   commands will detect it and remind you to do so if necessary.
   ```

   Выполняем команду `terraform validate`:

   ```
   ~/netology/devops-netology/2_virt-homeworks/07-terraform-02-syntax/terraform$ terraform validate
   Success! The configuration is valid.
   ```

   Выполняем команду `terraform plan`:

   ```
   ~/netology/devops-netology/2_virt-homeworks/07-terraform-02-syntax/terraform$ yc vpc subnet create --name subnet --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "My first subnet via YC"
   id: e9b9iuo9bmv8hcel7nhq
   folder_id: b1gtlsmjgcj4o3fefd5t
   created_at: "2022-07-07T06:27:26Z"
   name: subnet
   description: My first subnet via YC
   network_id: enp3q5ahjh1p92ie6dkv
   zone_id: ru-central1-a
   v4_cidr_blocks:
     - 10.1.2.0/24
   
   uralhouse@hp:~/netology/devops-netology/2_virt-homeworks/07-terraform-02-syntax/terraform$ terraform plan
   var.token
     Enter a value: AQAAAABctCg0AA**************************
   
   
   Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
     + create
   
   Terraform will perform the following actions:
   
     # yandex_compute_instance.default[0] will be created
     + resource "yandex_compute_instance" "default" {
         + created_at                = (known after apply)
         + folder_id                 = (known after apply)
         + fqdn                      = (known after apply)
         + hostname                  = (known after apply)
         + id                        = (known after apply)
         + metadata                  = {
             + "ssh-keys" = <<-EOT
                   ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzL4ePj76IXLOghNoYRdyiO7eky59TvNkrVqwFI3+FL1E8ikDz8c+gzNRetQMhKSBLWykPuS11dh9e0JOA/0NyXzDkWWH4kdrSBkeKcF2yc1Q03oyhH3DVtpptl13aJOalTrKvAFpRODTZHuPm2VOUs+YVBJwweeuP9xOCdR3bd6q+llU5Xd/CuAYcJyCEnKg7IjSxk0NziAuMGnyBqSbpamSHLLvmJh0XSWa/fsnt/d73x0O84tmQ+n8oTE5lq8qUbjcMdNHOGGMvbjRB6tatsneHjvnEe0ord7Q/ndgwjkuCvVP07dFKFNMdKymO2Raoc8VHYQA7RYfkvTp1b3VRf2oqlmqQ5T1lQMXSSVhxoig358xbvbcbFiDpXz01h3XLqJZe6EttLYGok6w7IafLx3bfvY2Bu1Y+tbloSv3+qP1f/WfmNZVP2VMP/PHEBVwS3HQQUIM7sTZzCrGpPYYIRZTyFelFcg0x/SNWDNOrMEJHdRbKW/HlLyc3VC4ynuE= uralhouse@hp
               EOT
           }
         + name                      = "node01"
         + network_acceleration_type = "standard"
         + platform_id               = "standard-v1"
         + service_account_id        = (known after apply)
         + status                    = (known after apply)
         + zone                      = (known after apply)
   
         + boot_disk {
             + auto_delete = true
             + device_name = (known after apply)
             + disk_id     = (known after apply)
             + mode        = (known after apply)
   
             + initialize_params {
                 + block_size  = (known after apply)
                 + description = (known after apply)
                 + image_id    = "fd81u2vhv3mc49l1ccbb"
                 + name        = (known after apply)
                 + size        = 20
                 + snapshot_id = (known after apply)
                 + type        = "network-hdd"
               }
           }
   
         + network_interface {
             + index              = (known after apply)
             + ip_address         = (known after apply)
             + ipv4               = true
             + ipv6               = (known after apply)
             + ipv6_address       = (known after apply)
             + mac_address        = (known after apply)
             + nat                = true
             + nat_ip_address     = (known after apply)
             + nat_ip_version     = (known after apply)
             + security_group_ids = (known after apply)
             + subnet_id          = "e9b9iuo9bmv8hcel7nhq"
           }
   
         + placement_policy {
             + host_affinity_rules = (known after apply)
             + placement_group_id  = (known after apply)
           }
   
         + resources {
             + core_fraction = 20
             + cores         = 2
             + memory        = 4
           }
   
         + scheduling_policy {
             + preemptible = (known after apply)
           }
       }
   
   Plan: 1 to add, 0 to change, 0 to destroy.
   
   Changes to Outputs:
     + cloud_id                                = "b1ghke5papbqdt8arsh2"
     + folder_id                               = "b1gtlsmjgcj4o3fefd5t"
     + private-ip-for-compute-instance-default = [
         + (known after apply),
       ]
     + public-ip-for-compute-instance-default  = [
         + (known after apply),
       ]
     + public-subnet-id-default                = [
         + "e9b9iuo9bmv8hcel7nhq",
       ]
     + zone                                    = "ru-central1-a"
   
   ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   
   Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
   ```
   
   Выполняем команду `terraform apply`:

   ```
   ~/netology/devops-netology/2_virt-homeworks/07-terraform-02-syntax/terraform$ terraform apply
   var.token
     Enter a value: AQAAAABctCg0AA**************************
   
   
   Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
     + create
   
   Terraform will perform the following actions:
   
     # yandex_compute_instance.default[0] will be created
     + resource "yandex_compute_instance" "default" {
         + created_at                = (known after apply)
         + folder_id                 = (known after apply)
         + fqdn                      = (known after apply)
         + hostname                  = (known after apply)
         + id                        = (known after apply)
         + metadata                  = {
             + "ssh-keys" = <<-EOT
                   ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzL4ePj76IXLOghNoYRdyiO7eky59TvNkrVqwFI3+FL1E8ikDz8c+gzNRetQMhKSBLWykPuS11dh9e0JOA/0NyXzDkWWH4kdrSBkeKcF2yc1Q03oyhH3DVtpptl13aJOalTrKvAFpRODTZHuPm2VOUs+YVBJwweeuP9xOCdR3bd6q+llU5Xd/CuAYcJyCEnKg7IjSxk0NziAuMGnyBqSbpamSHLLvmJh0XSWa/fsnt/d73x0O84tmQ+n8oTE5lq8qUbjcMdNHOGGMvbjRB6tatsneHjvnEe0ord7Q/ndgwjkuCvVP07dFKFNMdKymO2Raoc8VHYQA7RYfkvTp1b3VRf2oqlmqQ5T1lQMXSSVhxoig358xbvbcbFiDpXz01h3XLqJZe6EttLYGok6w7IafLx3bfvY2Bu1Y+tbloSv3+qP1f/WfmNZVP2VMP/PHEBVwS3HQQUIM7sTZzCrGpPYYIRZTyFelFcg0x/SNWDNOrMEJHdRbKW/HlLyc3VC4ynuE= uralhouse@hp
               EOT
           }
         + name                      = "node01"
         + network_acceleration_type = "standard"
         + platform_id               = "standard-v1"
         + service_account_id        = (known after apply)
         + status                    = (known after apply)
         + zone                      = (known after apply)
   
         + boot_disk {
             + auto_delete = true
             + device_name = (known after apply)
             + disk_id     = (known after apply)
             + mode        = (known after apply)
   
             + initialize_params {
                 + block_size  = (known after apply)
                 + description = (known after apply)
                 + image_id    = "fd81u2vhv3mc49l1ccbb"
                 + name        = (known after apply)
                 + size        = 20
                 + snapshot_id = (known after apply)
                 + type        = "network-hdd"
               }
           }
   
         + network_interface {
             + index              = (known after apply)
             + ip_address         = (known after apply)
             + ipv4               = true
             + ipv6               = (known after apply)
             + ipv6_address       = (known after apply)
             + mac_address        = (known after apply)
             + nat                = true
             + nat_ip_address     = (known after apply)
             + nat_ip_version     = (known after apply)
             + security_group_ids = (known after apply)
             + subnet_id          = "e9b9iuo9bmv8hcel7nhq"
           }
   
         + placement_policy {
             + host_affinity_rules = (known after apply)
             + placement_group_id  = (known after apply)
           }
   
         + resources {
             + core_fraction = 20
             + cores         = 2
             + memory        = 4
           }
   
         + scheduling_policy {
             + preemptible = (known after apply)
           }
       }
   
   Plan: 1 to add, 0 to change, 0 to destroy.
   
   Changes to Outputs:
     + cloud_id                                = "b1ghke5papbqdt8arsh2"
     + folder_id                               = "b1gtlsmjgcj4o3fefd5t"
     + private-ip-for-compute-instance-default = [
         + (known after apply),
       ]
     + public-ip-for-compute-instance-default  = [
         + (known after apply),
       ]
     + public-subnet-id-default                = [
         + "e9b9iuo9bmv8hcel7nhq",
       ]
     + zone                                    = "ru-central1-a"
   
   Do you want to perform these actions?
     Terraform will perform the actions described above.
     Only 'yes' will be accepted to approve.
   
     Enter a value: yes
   
   yandex_compute_instance.default[0]: Creating...
   yandex_compute_instance.default[0]: Still creating... [10s elapsed]
   yandex_compute_instance.default[0]: Still creating... [20s elapsed]
   yandex_compute_instance.default[0]: Still creating... [30s elapsed]
   yandex_compute_instance.default[0]: Creation complete after 31s [id=fhm5n5huq02r0fm5egvj]
   
   Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
   
   Outputs:
   
   cloud_id = "b1ghke5papbqdt8arsh2"
   folder_id = "b1gtlsmjgcj4o3fefd5t"
   private-ip-for-compute-instance-default = [
     "10.1.2.21",
   ]
   public-ip-for-compute-instance-default = [
     "51.250.85.243",
   ]
   public-subnet-id-default = [
     "e9b9iuo9bmv8hcel7nhq",
   ]
   zone = "ru-central1-a"
   ```
   
   Выполним вход на хост:
   
   ```
   :~$ ssh ubuntu@51.250.75.139
   Enter passphrase for key '/home/uralhouse/.ssh/id_rsa':
   Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-121-generic x86_64)
   
    * Documentation:  https://help.ubuntu.com
    * Management:     https://landscape.canonical.com
    * Support:        https://ubuntu.com/advantage
   
   The programs included with the Ubuntu system are free software;
   the exact distribution terms for each program are described in the
   individual files in /usr/share/doc/*/copyright.
   
   Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
   applicable law.
   
   To run a command as administrator (user "root"), use "sudo <command>".
   See "man sudo_root" for details.
   
   ubuntu@fhmum78q2n3tvin3mfjb:~$ cat /etc/*-release
   DISTRIB_ID=Ubuntu
   DISTRIB_RELEASE=20.04
   DISTRIB_CODENAME=focal
   DISTRIB_DESCRIPTION="Ubuntu 20.04.4 LTS"
   NAME="Ubuntu"
   VERSION="20.04.4 LTS (Focal Fossa)"
   ID=ubuntu
   ID_LIKE=debian
   PRETTY_NAME="Ubuntu 20.04.4 LTS"
   VERSION_ID="20.04"
   HOME_URL="https://www.ubuntu.com/"
   SUPPORT_URL="https://help.ubuntu.com/"
   BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
   PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
   VERSION_CODENAME=focal
   UBUNTU_CODENAME=focal
   ```
   
   В качестве результата задания предоставьте:
   
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?

   Packer собирает образ ami на ВМ. 

1. Ссылку на репозиторий с исходной конфигурацией терраформа.  

   [Репозиторий с исходной конфигурацией Terraform](terraform).
