source "yandex" "ubuntu-nginx" {
  
  token               = "AQAAAAADDuzoAATuwU3ctvU0LUa4lBmRvPScfso"
  folder_id           = "b1g2fc722vnsbb1o1bhg"
  source_image_family = "ubuntu-2004-lts"
  ssh_username        = "ubuntu"
  use_ipv4_nat        = "true"
  image_description   = "my custom ubuntu with nginx"
  image_family        = "ubuntu-2004-lts"
  image_name          = "my-ubuntu-nginx"
  subnet_id           = "e9b8ueh92u9rjj7k6fqq"
  disk_type           = "network-ssd"
  zone                = "ru-central1-a"
}
 
build {
  sources = ["source.yandex.ubuntu-nginx"]
 
  provisioner "shell" {
    inline = ["sudo apt-get update -y", 
              "sudo apt-get install -y nginx", 
              "sudo systemctl enable nginx.service"
             ]
  }
} 