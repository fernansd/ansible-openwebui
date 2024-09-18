#!/usr/bin/env bash

#curl -s -kL https://ipinfo.io | jq -r ".ip"
# Devolver como JSON. Formato necesario para Terraform
curl -s -kL https://ipinfo.io | jq -r "{ip: .ip}"

