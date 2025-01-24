provider "docker" {}

resource "docker_network" "gitea" {}

resource "docker_container" "gitea" {
  name  = "gitea"
  image = "gitea/gitea:1.22.6"
  restart = "always"

  networks = [docker_network.gitea.name]

  environment = {
    USER_UID = "1000"
    USER_GID = "1000"
  }

  volumes {
    host_path      = "./gitea"
    container_path = "/data"  # Modificar esta línea si se cambia la ruta de almacenamiento de Gitea
  }

  volumes {
    host_path      = "/etc/timezone"
    container_path = "/etc/timezone"
    read_only      = true  # No modificar, mantiene la configuración horaria
  }

  volumes {
    host_path      = "/etc/localtime"
    container_path = "/etc/localtime"
    read_only      = true  # No modificar, mantiene la configuración horaria
  }

  ports {
    internal = 3000
    external = var.web_port  # Modificar esta línea para establecer el puerto web de Gitea
  }

  ports {
    internal = 22
    external = var.ssh_port  # Modificar esta línea para establecer el puerto SSH de Gitea
  }
}

resource "docker_container" "portainer" {
  name  = "portainer"
  image = "portainer/portainer-ce:latest"
  restart = "unless-stopped"

  ports {
    internal = 9000
    external = var.puerto  # Modificar esta línea para establecer el puerto de acceso a Portainer
  }

  volumes {
    volume_name    = docker_volume.portainer_data.name
    container_path = "/data"
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"  # No modificar, necesario para la comunicación con Docker
  }
}

resource "docker_volume" "portainer_data" {}

variable "web_port" {}  # Modificar esta línea para definir el puerto web de Gitea
variable "ssh_port" {}  # Modificar esta línea para definir el puerto SSH de Gitea
variable "puerto" {}  # Modificar esta línea para definir el puerto de Portainer
