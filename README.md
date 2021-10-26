# devops-netology
#Игнорируются в любых директориях и поддиректориях папка .terraform
**/.terraform/*

#Игнорируются все файлы с расширением или любые файлы имеющие в названии тест.tfstate   
*.tfstate
*.tfstate.*

#Игнорируется файл crash.log
crash.log

#Игнорируются файлы с расширением
*.tfvars

#Игнорируются файлы
override.tf
override.tf.json
*_override.tf
*_override.tf.json

#Игнорируются файлы
.terraformrc
terraform.rc
