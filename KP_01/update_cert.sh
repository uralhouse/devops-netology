#!/usr/bin/env bash

###############Скрипт генерации нового сертификата для домена####################
#ПЕРЕМЕННЫЕ
DOMAIN=example.com
# Время жизни сертификата для домена (1 месяц)
TTL_DOMAIN=720h
# Путь нахождения скрипта
DIR_SERT=/home/vagrant/cert
# Экспорт переменной Vault
export VAULT_ADDR='http://127.0.0.1:8200'

vault write -format=json pki_int/issue/example-dot-com common_name=$DOMAIN ttl=$TTL_DOMAIN >  $DIR_SERT/website.crt

#Save cert
cat $DIR_SERT/website.crt | jq -r .data.certificate >  $DIR_SERT/example.com.crt.pem
cat $DIR_SERT/website.crt | jq -r .data.ca_chain[] >>  $DIR_SERT/example.com.crt.pem
cat $DIR_SERT/website.crt | jq -r .data.private_key >  $DIR_SERT/example.com.crt.key

#Reload Nginx
systemctl reload nginx
