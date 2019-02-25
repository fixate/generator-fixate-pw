#!/bin/bash

# https://serverfault.com/a/870832

if [ -z "$1" ]; then
  hostname="$HOSTNAME"
else
  hostname="$1"
fi

local_openssl_config="
[ req ]
prompt = no
distinguished_name = req_distinguished_name
x509_extensions = san_self_signed
[ req_distinguished_name ]
CN=$hostname
[ san_self_signed ]
subjectAltName = DNS:$hostname, DNS:localhost
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = CA:true
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment, keyCertSign, cRLSign
extendedKeyUsage = serverAuth, clientAuth, timeStamping
"

# docker example: https://docs.docker.com/ee/ucp/interlock/usage/tls/
openssl req \
  -new \
  -newkey rsa:4096 \
  -days 36500 \
  -nodes \
  -x509 \
  -subj "/C=US/ST=CA/L=SF/O=LocalDev-company" \
  -config <(echo "$local_openssl_config") \
  -keyout server.key \
  -out server.crt
