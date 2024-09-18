#!/usr/bin/env bash

if [ -z $1 ]; then                                                                                                                                                                                                                                                                    echo "Error. Hay que proporcionar una IP como parámetro."                                                                                                                                                                                                                     exit 1
fi
source /home/nuc/software/ansible/activate
echo $(which ansible-playbook)
ansible-playbook -i "$1," ansible/configurar-splunk-server.yaml --key-file ~/.ssh/ansible
