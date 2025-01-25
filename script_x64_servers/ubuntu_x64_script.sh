#!/bin/bash

# --- Instalar ZeroTier ---
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/main/doc/contact%40zerotier.com.gpg' | gpg --import && 
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi

# --- Actualizar el sistema ---
sudo apt update && sudo apt upgrade -y

# --- Instalar paquetes necesarios ---
sudo apt install -y apt-transport-https ca-certificates curl gnupg software-properties-common

# --- Añadir la clave GPG de Docker ---
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# --- Añadir el repositorio de Docker para Ubuntu ---
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# --- Actualizar los repositorios ---
sudo apt update

# --- Instalar Docker ---
sudo apt install -y docker-ce docker-ce-cli containerd.io

# --- Habilitar y arrancar Docker ---
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker --no-pager

# --- Instalar la última versión de Docker Compose ---
DOCKER_COMPOSE_URL=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | grep "$(uname -s)-$(uname -m)" | cut -d '"' -f 4)

if [ -z "$DOCKER_COMPOSE_URL" ]; then
    echo "No se pudo obtener la URL de Docker Compose. Descargando manualmente..."
    DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)"
fi

sudo curl -L "$DOCKER_COMPOSE_URL" -o /usr/local/bin/docker-compose

# --- Aplicar permisos de ejecución ---
sudo chmod +x /usr/local/bin/docker-compose

# --- Verificar que Docker Compose esté instalado ---
if ! command -v docker-compose &> /dev/null; then
    echo "docker-compose no encontrado, intentando instalar como plugin..."
    sudo apt install -y docker-compose-plugin
fi

docker-compose --version || docker compose version

# --- Mostrar mensaje de éxito ---
echo "ZeroTier, Docker y la última versión de Docker Compose han sido instalados exitosamente."
