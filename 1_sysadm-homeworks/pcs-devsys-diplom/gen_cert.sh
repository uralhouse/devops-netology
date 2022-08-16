#!/usr/bin/env bash

###############Скрипт генерации новых сертификатов Vault####################
#ПЕРЕМЕННЫЕ
DOMAIN=example.com
#Время жизни корневого сертификата (10 лет)
TTL_ROOT_CA=87600h
# Время жизни промежуточного сертификата (5 лет)
TTL_IM_CA=43800h
# Время жизни для роли (1 год) 
TTL_ROLES=8760h
# Время жизни сертификата для домена (1 месяц)
TTL_DOMAIN=720h
# Путь нахождения скрипта
DIR_SERT=/home/vagrant/cert

# Экспорт переменной Vault
export VAULT_ADDR='http://127.0.0.1:8200'

#Step 1: Generate root CA
vault secrets enable pki
vault secrets tune -max-lease-ttl=$TTL_ROOT_CA pki
vault write -field=certificate pki/root/generate/internal common_name=$DOMAIN ttl=$TTL_ROOT_CA > $DIR_SERT/CA_cert.crt
vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

#Step 2: Generate intermediate CA
vault secrets enable -path=pki_int pki
vault secrets tune -max-lease-ttl=$TTL_IM_CA pki_int
vault write -format=json pki_int/intermediate/generate/internal common_name="$DOMAIN Intermediate Authority" | jq -r '.data.csr' > $DIR_SERT/pki_intermediate.csr
vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl=$TTL_IM_CA | jq -r '.data.certificate' > $DIR_SERT/intermediate.cert.pem
vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem

#Step 3: Create a role
vault write pki_int/roles/example-dot-com allowed_domains=$DOMAIN allow_bare_domains=true allow_subdomains=true max_ttl=$TTL_ROLES

#Step 4: Request certificates
vault write -format=json pki_int/issue/example-dot-com common_name=$DOMAIN ttl=$TTL_DOMAIN > $DIR_SERT/website.crt

#Step 5: Save cert
cat $DIR_SERT/website.crt | jq -r .data.certificate >  $DIR_SERT/example.com.crt.pem
cat $DIR_SERT/website.crt | jq -r .data.ca_chain[] >>  $DIR_SERT/example.com.crt.pem
cat $DIR_SERT/website.crt | jq -r .data.private_key >  $DIR_SERT/example.com.crt.key

#Step 6: Reload Nginx
systemctl reload nginx

