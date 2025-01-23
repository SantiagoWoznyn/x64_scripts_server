#!/bin/bash

# Solicitar el puerto
read -p "Ingresa el puerto para NexTerm (por defecto 6989): " PORT
PORT=${PORT:-6989}

# Solicitar el path del volumen
read -p "Ingresa la ruta para el volumen (por defecto ./nexterm_data): " VOLUME_PATH
VOLUME_PATH=${VOLUME_PATH:-./nexterm_data}
VOLUME_PATH=$(realpath "$VOLUME_PATH")  # Obtener la ruta absoluta

# Crear el archivo docker-compose.yml
cat <<EOF > docker-compose.yml
services:
  nexterm:
    ports:
      - "$PORT:$PORT"
    restart: always
    volumes:
      - "$VOLUME_PATH:/app/data"
    image: germannewsmaker/nexterm:1.0.2-OPEN-PREVIEW
volumes:
  nexterm:
EOF

echo "Archivo docker-compose.yml generado con éxito."

# Ejecutar docker-compose up -d
echo "Ejecutando docker-compose up -d..."
sudo docker-compose up -d

