# Решение домашнего задания к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
  а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
  [здесь](https://www.terraform.io/docs/backends/types/s3.html).

1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 

   Создан файл backend.conf со следующим содержимым:

   ```
   endpoint   = "storage.yandexcloud.net"
   bucket     = "uralhouse-tf"
   region     = "ru-central1"
   key        = "terraform.tfstate"
   access_key = "YCAJE********"
   secret_key = "YCMjm********"
   skip_region_validation      = true
   skip_credentials_validation = true

Запуск осуществляется командой `terraform init -backend-config=backend.conf`

## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
    dynamodb.
    * иначе будет создан локальный файл со стейтами.  

    ```
    ~/netology/devops-netology/2_virt-homeworks/07-terraform-03-basic/terraform$ terraform init -backend-config=backend.conf
    
    Initializing the backend...
    
    Successfully configured the backend "s3"! Terraform will automatically
    use this backend unless the backend configuration changes.
    
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

1. Создайте два воркспейса `stage` и `prod`.

    ```
    ~/netology/devops-netology/2_virt-homeworks/07-terraform-03-basic/terraform$ terraform workspace new stage
    Created and switched to workspace "stage"!
    
    You're now on a new, empty workspace. Workspaces isolate their state,
    so if you run "terraform plan" Terraform will not see any existing state
    for this configuration.
    
    ~/netology/devops-netology/2_virt-homeworks/07-terraform-03-basic/terraform$ terraform workspace new prod
    Created and switched to workspace "prod"!
    
    You're now on a new, empty workspace. Workspaces isolate their state,
    so if you run "terraform plan" Terraform will not see any existing state
    for this configuration.
    
    ~/netology/devops-netology/2_virt-homeworks/07-terraform-03-basic/terraform$ terraform workspace select prod
    

1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
  использовались разные `instance_type`.

1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 

1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.

1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
  жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.

1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.

  ```
  ~/netology/devops-netology/2_virt-homeworks/07-terraform-03-basic/terraform$ terraform workspace list
    default
  * prod
    stage

* Вывод команды `terraform plan` для воркспейса `prod`.  

  ```
  ~/netology/devops-netology/2_virt-homeworks/07-terraform-03-basic/terraform$ terraform plan
  var.token
    Enter a value: AQAAAABctCg0A***********
  
  
  Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create
  
  Terraform will perform the following actions:
  
    # yandex_compute_instance.another["vm1"] will be created
    + resource "yandex_compute_instance" "another" {
        + created_at                = (known after apply)
        + folder_id                 = (known after apply)
        + fqdn                      = (known after apply)
        + hostname                  = (known after apply)
        + id                        = (known after apply)
        + metadata                  = {
            + "ssh-keys" = <<-EOT
                  ubuntu:ssh-rsa AAAAB3Nza********
              EOT
          }
        + name                      = "node-01-prod"
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
                + image_id    = "fd8qs44945ddtla09hnr"
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
            + core_fraction = 100
            + cores         = 4
            + memory        = 4
          }
  
        + scheduling_policy {
            + preemptible = (known after apply)
          }
      }
  
    # yandex_compute_instance.another["vm2"] will be created
    + resource "yandex_compute_instance" "another" {
        + created_at                = (known after apply)
        + folder_id                 = (known after apply)
        + fqdn                      = (known after apply)
        + hostname                  = (known after apply)
        + id                        = (known after apply)
        + metadata                  = {
            + "ssh-keys" = <<-EOT
                  ubuntu:ssh-rsa AAAAB3N********
              EOT
          }
        + name                      = "node-02-prod"
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
                + image_id    = "fd8qs44945ddtla09hnr"
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
            + core_fraction = 100
            + cores         = 4
            + memory        = 4
          }
  
        + scheduling_policy {
            + preemptible = (known after apply)
          }
      }
  
    # yandex_compute_instance.default[0] will be created
    + resource "yandex_compute_instance" "default" {
        + created_at                = (known after apply)
        + folder_id                 = (known after apply)
        + fqdn                      = (known after apply)
        + hostname                  = (known after apply)
        + id                        = (known after apply)
        + metadata                  = {
            + "ssh-keys" = <<-EOT
                  ubuntu:ssh-rsa AAAAB3N********
              EOT
          }
        + name                      = "node01-prod"
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
                + image_id    = "fd8qs44945ddtla09hnr"
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
            + core_fraction = 100
            + cores         = 4
            + memory        = 4
          }
  
        + scheduling_policy {
            + preemptible = (known after apply)
          }
      }
  
    # yandex_compute_instance.default[1] will be created
    + resource "yandex_compute_instance" "default" {
        + created_at                = (known after apply)
        + folder_id                 = (known after apply)
        + fqdn                      = (known after apply)
        + hostname                  = (known after apply)
        + id                        = (known after apply)
        + metadata                  = {
            + "ssh-keys" = <<-EOT
                  ubuntu:ssh-rsa AAAAB3Nz******
              EOT
          }
        + name                      = "node02-prod"
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
                + image_id    = "fd8qs44945ddtla09hnr"
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
            + core_fraction = 100
            + cores         = 4
            + memory        = 4
          }
  
        + scheduling_policy {
            + preemptible = (known after apply)
          }
      }
  
  Plan: 4 to add, 0 to change, 0 to destroy.
  
  Changes to Outputs:
    + cloud_id                                = "b1ghke5papbqdt8arsh2"
    + folder_id                               = "b1gtlsmjgcj4o3fefd5t"
    + private-ip-for-compute-instance-another = [
        + (known after apply),
        + (known after apply),
      ]
    + private-ip-for-compute-instance-default = [
        + (known after apply),
        + (known after apply),
      ]
    + public-ip-for-compute-instance-another  = [
        + (known after apply),
        + (known after apply),
      ]
    + public-ip-for-compute-instance-default  = [
        + (known after apply),
        + (known after apply),
      ]
    + public-subnet-id-another                = [
        + "e9b9iuo9bmv8hcel7nhq",
        + "e9b9iuo9bmv8hcel7nhq",
      ]
    + public-subnet-id-default                = [
        + "e9b9iuo9bmv8hcel7nhq",
        + "e9b9iuo9bmv8hcel7nhq",
      ]
    + zone                                    = "ru-central1-a"
  
  ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  
  Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
  



Вывод `terraform apply`:

```
terraform apply
var.token
  Enter a value: AQAAAABctCg0AA************


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.another["vm1"] will be created
  + resource "yandex_compute_instance" "another" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3Nz***********
            EOT
        }
      + name                      = "node-01-prod"
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
              + image_id    = "fd8qs44945ddtla09hnr"
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
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.another["vm2"] will be created
  + resource "yandex_compute_instance" "another" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3Nz********
            EOT
        }
      + name                      = "node-02-prod"
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
              + image_id    = "fd8qs44945ddtla09hnr"
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
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.default[0] will be created
  + resource "yandex_compute_instance" "default" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB************
            EOT
        }
      + name                      = "node01-prod"
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
              + image_id    = "fd8qs44945ddtla09hnr"
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
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.default[1] will be created
  + resource "yandex_compute_instance" "default" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB********
            EOT
        }
      + name                      = "node02-prod"
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
              + image_id    = "fd8qs44945ddtla09hnr"
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
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + cloud_id                                = "b1ghke5papbqdt8arsh2"
  + folder_id                               = "b1gtlsmjgcj4o3fefd5t"
  + private-ip-for-compute-instance-another = [
      + (known after apply),
      + (known after apply),
    ]
  + private-ip-for-compute-instance-default = [
      + (known after apply),
      + (known after apply),
    ]
  + public-ip-for-compute-instance-another  = [
      + (known after apply),
      + (known after apply),
    ]
  + public-ip-for-compute-instance-default  = [
      + (known after apply),
      + (known after apply),
    ]
  + public-subnet-id-another                = [
      + "e9b9iuo9bmv8hcel7nhq",
      + "e9b9iuo9bmv8hcel7nhq",
    ]
  + public-subnet-id-default                = [
      + "e9b9iuo9bmv8hcel7nhq",
      + "e9b9iuo9bmv8hcel7nhq",
    ]
  + zone                                    = "ru-central1-a"

Do you want to perform these actions in workspace "prod"?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_compute_instance.default[1]: Creating...
yandex_compute_instance.another["vm1"]: Creating...
yandex_compute_instance.another["vm2"]: Creating...
yandex_compute_instance.default[0]: Creating...
yandex_compute_instance.default[1]: Still creating... [10s elapsed]
yandex_compute_instance.another["vm1"]: Still creating... [10s elapsed]
yandex_compute_instance.another["vm2"]: Still creating... [10s elapsed]
yandex_compute_instance.default[0]: Still creating... [10s elapsed]
yandex_compute_instance.another["vm1"]: Still creating... [20s elapsed]
yandex_compute_instance.default[1]: Still creating... [20s elapsed]
yandex_compute_instance.default[0]: Still creating... [20s elapsed]
yandex_compute_instance.another["vm2"]: Still creating... [20s elapsed]
yandex_compute_instance.another["vm2"]: Creation complete after 25s [id=fhmvc07l5j16vsuomtog]
yandex_compute_instance.another["vm1"]: Creation complete after 26s [id=fhmbgrebls324c6t8m1g]
yandex_compute_instance.default[1]: Creation complete after 26s [id=fhm9gr8t8q2is91n7bka]
yandex_compute_instance.default[0]: Creation complete after 26s [id=fhmpd91qhpt0loki6fa6]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

cloud_id = "b1ghke5papbqdt8arsh2"
folder_id = "b1gtlsmjgcj4o3fefd5t"
private-ip-for-compute-instance-another = [
  "10.1.2.19",
  "10.1.2.18",
]
private-ip-for-compute-instance-default = [
  "10.1.2.8",
  "10.1.2.20",
]
public-ip-for-compute-instance-another = [
  "51.250.69.14",
  "51.250.74.169",
]
public-ip-for-compute-instance-default = [
  "51.250.90.176",
  "51.250.64.225",
]
public-subnet-id-another = [
  "e9b9iuo9bmv8hcel7nhq",
  "e9b9iuo9bmv8hcel7nhq",
]
public-subnet-id-default = [
  "e9b9iuo9bmv8hcel7nhq",
  "e9b9iuo9bmv8hcel7nhq",
]
zone = "ru-central1-a"

```
