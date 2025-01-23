
#!/bin/bash

# Solicitar el puerto para Portainer
read -p "¿En qué puerto deseas instalar Portainer (por defecto 9000)? " puerto
puerto=${puerto:-9000}

# Crear el archivo docker-compose.yml con el puerto ingresado
cat <<EOF > docker-compose.yml
version: "3"
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    ports:
      - "$puerto:9000"
    volumes:
      - portainer_data:/data
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped
volumes:
  portainer_data:
EOF

echo "Archivo docker-compose.yml creado con éxito. Puedes iniciar Portainer con 'docker-compose up -d'."

# Iniciar Portainer con Docker Compose
echo "Iniciando Portainer..."
docker-compose up -d

echo "Portainer está ahora corriendo en el puerto $puerto."