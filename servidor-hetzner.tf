###
# Configuración previa
###

terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 0.13"
}

variable "hcloud_token" {
  sensitive = true
}

# Obtener IP del host actual para permitirla en el firewall de Hetzner
data "external" "ip-admin" {
  program = [
    "sh", "${path.module}/scripts/get_ip.sh"
  ]
}

# Clave SSH para login en la máquina
resource "hcloud_ssh_key" "ansible" {
  name       = "Ansible"
  public_key = file("clave-ssh.pub")
}

# Conexión Hetzner
provider "hcloud" {
  token = var.hcloud_token
}

###
# Recursos infraestructura
###

# Reglas de acceso FW desde bastion
resource "hcloud_firewall" "fw_servidor" {
  name = "acceso remoto admin"
  # Acceso SSH
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [data.external.ip-admin.result.ip]
  }
  # Acceso servicios
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "1-65000"
    source_ips = [data.external.ip-admin.result.ip]
  }
}

# Servidor
resource "hcloud_server" "webgpt" {
  name   = "webgpt"
  image  = "ubuntu-24.04"
  labels = { "terraform" : "" }
  # 2 vCPUs / 4GB RAM
  server_type = "cx22"
  # 4 vCPUs / 8GB RAM
  # server_type = "cx32"
  ssh_keys     = [hcloud_ssh_key.ansible.id]
  firewall_ids = [hcloud_firewall.fw_servidor.id]

  # Sonda para comprobar que se ha levantado el servidor y funciona el acceso
  provisioner "remote-exec" {
    connection {
      host        = self.ipv4_address
      user        = "root"
      private_key = file("clave-ssh.key")
    }

    inline = ["echo 'connected ${self.ipv4_address}!'"]
  }

  lifecycle {
    ignore_changes = [
      ssh_keys,
    ]
  }
}

###
# Variables de salida
###
output "ip-admin" {
  value = data.external.ip-admin.result.ip
}

output "ip-servidor" {
  value = hcloud_server.webgpt.ipv4_address
}
