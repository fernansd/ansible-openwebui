Despliegue OpenWebUI con Ansible
====================================
Generar un par de claves para la instancia en la nube.
```bash
ssh-keygen -t ed25519 -o -a 100 -f ~/.ssh/cloud-openwebui
```
Se recomienda crear un enlace simbólico a la clave en el directorio actual.
```bash
ln -s ~/.ssh/cloud-openwebui clave-ssh.key
ln -s ~/.ssh/cloud-openwebui.pub clave-ssh.pub
```





## Instalar Ansible
```bash
# Gestión de herramientas de sistema. Crea un entorno para cada herramienta y lo añade al path
python -m pip install pipx
# Instalar Ansible. Basado en la documentación: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pipx
pipx install --include-deps ansible
```

