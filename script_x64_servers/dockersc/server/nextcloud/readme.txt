MODIFICAR ARCHIVOS EN EL VOLUMEN, ES DECIR CREAR ELIMINAR MOVER, ETC
SI BIEN PODES HACERLO DE ACUERDO AL USUARIO ,
ACA TENES EL COMANDO PARA ACTUALIZAR LOS ARCHIVOS PARA QUE APAREZCAN EN LA INTERFAZ DE NEXTCLOUD :

        sudo docker exec -u www-data nextcloud_app php occ files:scan --all
O
        sudo -u www-data php /var/www/html/nextcloud/occ files:scan --all
