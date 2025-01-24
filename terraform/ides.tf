provider "docker" {}

resource "docker_container" "code_server" {
  name  = "code-server"
  image = "lscr.io/linuxserver/code-server:latest"
  restart = "unless-stopped"

  environment = {
    PUID                = "1000"
    PGID                = "1000"
    TZ                  = "Etc/UTC"
    PASSWORD            = "${var.password}"  # Modificar esta línea para definir la contraseña de acceso
    HASHED_PASSWORD     = ""  # Modificar esta línea si se usa una contraseña encriptada
    SUDO_PASSWORD       = "${var.password}"  # Modificar esta línea si se requiere contraseña de sudo
    SUDO_PASSWORD_HASH  = ""  # Modificar esta línea si se usa una contraseña encriptada para sudo
    PROXY_DOMAIN        = "${var.proxy_domain}"  # Modificar esta línea si se usa un dominio proxy
    DEFAULT_WORKSPACE   = "/config/workspace"  # Modificar esta línea si se quiere cambiar la ruta de trabajo
  }

  volumes {
    host_path      = var.volumen_path  # Modificar esta línea para definir la ruta del volumen
    container_path = "/config"
  }

  ports {
    internal = 8443
    external = var.puerto  # Modificar esta línea para definir el puerto de acceso a Code-Server
  }
}

variable "password" {}  # Modificar esta línea para definir la contraseña de acceso
variable "proxy_domain" {}  # Modificar esta línea para definir el dominio proxy
variable "volumen_path" {}  # Modificar esta línea para definir la ruta del volumen
variable "puerto" {}  # Modificar esta línea para definir el puerto externo

