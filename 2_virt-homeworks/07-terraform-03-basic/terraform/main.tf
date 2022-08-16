data "yandex_client_config" "me" {}

data "yandex_compute_image" "my_image" {
  family = "ubuntu-2004-lts"
}

data "yandex_vpc_subnet" "my_subnet" {
  name = var.subnet_name
}

resource "yandex_compute_instance" "default" {
  count = "${terraform.workspace == "prod" ? 2 : 1}"
  name = "node0${count.index+1}-${terraform.workspace}"

  resources {
    cores         = "${terraform.workspace == "prod" ? 4 : 2}"
    memory        = 4
    core_fraction = "${terraform.workspace == "prod" ? 100 : 20}"
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 20
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.my_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("/home/uralhouse/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "another" {
  for_each = var.hosts[terraform.workspace]
  name = each.value.name

  resources {
    cores         = each.value.cores
    memory        = 4
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 20
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.my_subnet.id
    nat       = true
  }
    metadata = {
    ssh-keys = "ubuntu:${file("/home/uralhouse/.ssh/id_rsa.pub")}"
#    user-data = "${file("meta.txt")}"
  }
}

