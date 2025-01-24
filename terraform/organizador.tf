provider "docker" {}

resource "docker_container" "affine" {
  name  = "affine"
  image = "toeverything/affine:latest"
  restart = "unless-stopped"

  environment = {
    AFFINE_REVISION            = "stable"  # Modificar esta línea para cambiar la versión (stable, beta, canary)
    PORT                       = var.port  # Modificar esta línea para definir el puerto del servidor
    # AFFINE_SERVER_HTTPS       = "true"  # Descomentar y modificar esta línea si se requiere HTTPS
    # AFFINE_SERVER_HOST        = "affine.yourdomain.com"  # Modificar esta línea si se usa un dominio personalizado
    # AFFINE_SERVER_EXTERNAL_URL = "https://affine.yourdomain.com"  # Modificar si se usa una URL externa
    DB_DATA_LOCATION           = var.db_data_location  # Modificar esta línea para la ubicación de la base de datos
    UPLOAD_LOCATION            = var.upload_location  # Modificar esta línea para la ubicación de archivos subidos
    CONFIG_LOCATION            = var.config_location  # Modificar esta línea para la ubicación de la configuración
    DB_USERNAME                = "affine"  # Modificar esta línea para definir el usuario de la base de datos
    DB_PASSWORD                = var.db_password  # Modificar esta línea para definir la contraseña de la base de datos
    DB_DATABASE                = "affine"  # Modificar esta línea para definir el nombre de la base de datos
  }

  volumes {
    host_path      = var.db_data_location
    container_path = "/var/lib/postgresql/data"
  }

  volumes {
    host_path      = var.upload_location
    container_path = "/uploads"
  }

  volumes {
    host_path      = var.config_location
    container_path = "/config"
  }

  ports {
    internal = 3010
    external = var.port  # Modificar esta línea para definir el puerto de acceso a AFFiNE
  }
}

variable "port" {}  # Modificar esta línea para definir el puerto del servidor
variable "db_data_location" {}  # Modificar esta línea para la ubicación de la base de datos
variable "upload_location" {}  # Modificar esta línea para la ubicación de archivos subidos
variable "config_location" {}  # Modificar esta línea para la ubicación de la configuración
variable "db_password" {}  # Modificar esta línea para definir la contraseña de la base de datos

