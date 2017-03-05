# DEVOPS-SEED

## Descripción

Desplieque de un arquitectura basada en microservicios mediante contenedores Docker. Comprende los siguientes servicios:

* NGINX: Servidor web que recibe las peticiones y las distribuye hacia el resto de microservicios. También sirve los archivos estáticos de cada uno de ellos. Además sirve directamente una aplicación **ANGULARJS** recién creada, también como archivos estáticos.

* DJANGO: Aplicación Django recién creada. Se llega a ella a través del servidor **NGINX**, bien por subdominio (por ejemplo http://django.devops-seed.com) o bien por terminación de la URL (por ejemplo http://www.devops-seed.com/django). Se utiliza **gunicorn** para servir la aplicación y **Circus** como gestor de procesos, para asegurar su arranque automático en caso de caída. Los archivo estáticos son servidos directamente por **NGINX**.

* NODEJS: Aplicación **Express** recién creada. Se llega a ella a través del servidor **NGINX**, bien por subdominio (por ejemplo http://nodejs.devops-seed.com) o bien por terminación de la URL (por ejemplo http://www.devops-seed-com/nodejs). Se utiliza **PM2** como gestor de procesos, corriendo la aplicación en modo cluster, con dos nodos. Los archivos estáticos son servidos directamente por **NGINX**.

## Entorno de desarrollo

### Requisitos previos

* Instalar [Docker Compose](https://docs.docker.com/compose/install/)
* Definir los siguientes dominios ficticios en el archivo hosts:
```
127.0.0.1   www.devops-seed.com
127.0.0.1   django.devops-seed.com
127.0.0.1   nodejs.devops-seed.com
```

### Arranque de servicios

Ejecutar el siguiente script:

```bash
./start_services.sh
```

### Logs

Los logs de todos los servicios se recogen en una ubicación única de la máquina anfitriona: 

```bash
~/log
```

Para monitorizarlos en tiempo real se puede utilizar el siguiente comando:

```bash
tail -f ~/log/*/*
```

### Acceso a la consola de los contenedores

Se puede acceder a la consola de cada uno de los contenedores con los siguientes respectivos comandos:

```bash
docker exec -it $(docker ps -q -f name=nginx) /bin/bash
docker exec -it $(docker ps -q -f name=django) /bin/bash
docker exec -it $(docker ps -q -f name=nodejs) /bin/bash
```
