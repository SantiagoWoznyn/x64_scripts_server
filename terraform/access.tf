provider "docker" {}

resource "docker_volume" "nexterm" {}
resource "docker_volume" "homarr" {}

resource "docker_container" "nexterm" {
  name  = "nexterm"
  image = "germannewsmaker/nexterm:1.0.2-OPEN-PREVIEW"
  restart = "always"

  ports {
    internal = var.port  # Modificar esta línea para establecer el puerto interno de Nexterm
    external = var.port  # Modificar esta línea para establecer el puerto externo de Nexterm
  }

  volumes {
    volume_name    = docker_volume.nexterm.name
    container_path = "/app/data"  # Modificar esta línea si se cambia la ruta de almacenamiento de datos de Nexterm
  }
}

resource "docker_container" "homarr" {
  name  = "homarr"
  image = "ghcr.io/homarr-labs/homarr:latest"
  restart = "unless-stopped"

  ports {
    internal = 7575  # No modificar, puerto interno fijo de Homarr
    external = var.port  # Modificar esta línea para establecer el puerto externo de Homarr
  }

  volumes {
    volume_name    = docker_volume.homarr.name
    container_path = "/appdata"  # Modificar esta línea si se cambia la ruta de almacenamiento de datos de Homarr
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"  # No modificar, necesario para la comunicación con Docker
  }

  env = [
    "SECRET_ENCRYPTION_KEY=${var.secret_key}"  # Modificar esta línea para definir la clave de cifrado
  ]
}

variable "port" {}  # Modificar esta línea para definir el puerto usado por ambos contenedores
variable "volume_path" {}  # Modificar esta línea para definir la ruta del volumen
variable "secret_key" {}  # Modificar esta línea para definir la clave de cifrado
