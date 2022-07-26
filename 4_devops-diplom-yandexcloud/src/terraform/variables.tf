#Токен доступа к yandex.cloud
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
#Белый IP
variable "yc_dedicated_ip" {
  default = "62.84.114.108"
}
#Доменное имя
variable "domain_name" {
  type    = string
  default = "uralhouse.site"
}
