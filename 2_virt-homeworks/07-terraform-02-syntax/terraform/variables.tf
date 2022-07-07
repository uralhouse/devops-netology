#keys
variable "token" {
  type      = string
  sensitive = true
}

#ID облака
variable "cloud_id" {
  type    = string
  default = "b1ghke5papbqdt8arsh2"
}

#ID каталога
variable "folder_id" {
  type    = string
  default = "b1gtlsmjgcj4o3fefd5t"
}

#Зона доступности
variable "zone" {
  type    = string
  default = "ru-central1-a"
}

#Имя подсети, в которой создаются ВМ
variable "subnet_name" {
  type    = string
  default = "subnet"
}

