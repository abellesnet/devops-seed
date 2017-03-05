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

## Despliegue en Amazon VPC

En los siguientes puntos se describe cómo realizar el despliegue en Amazon VPC. Para ello haremos uso de un repositorio de imágenes Docker, en el que iremos subiendo las distintas versiones de nuestros programas, y un servidor Ubuntu en el que haremos el despliegue propiamente dicho de estas imágenes con Docker Compose, de manera similar a como lo desplegamos en el entorno de desarrollo.

### Requisitos previos

#### Amazon VPC

* Lanzar una instancia en EC2, preferiblemente con Ubuntu, en la que deberemos:
    * Instalar la interfaz de linea de comandos de [AWS](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
    * Configurar la interfaz de linea de comandos de [AWS](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-quick-configuration)
    * Instalar [Docker Compose](https://docs.docker.com/v1.13/engine/installation/linux/ubuntu/)

* Asociar a la instancia una IP pública fija con [Elastic IP](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)

* Crear los siguientes repositorios en el Registro de Contenedores de Amazon [ECS](http://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html):
    * devops/nginx
    * devops/django
    * devops/nodejs

#### Entorno de desarrollo

* Instalar la interfaz de linea de comandos de [AWS](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* Configurar la interfaz de linea de comandos de [AWS](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-quick-configuration)
* Tener disponible el archivo *credenciales.pem* que necesitaremos para autenticarnos contra el servidor de producción en EC2

### Despliegue

El despliegue se realizará siguiendo los siguientes pasos:

1. Ejecutar el script *./deploy_asw.sh*, que hará lo siguiente:
    * Reconstruir las imágenes de los contenedores en local
    * Actualizar estas imágenes en los repositorios de Amazon ECS
    * Generar el archivo *docker-compose.prod.yml* con los tags de las nuevas versiones
    * Copiar los archivos necesarios al servidor remoto en EC2

2. Ejecutar el script *./start_services_ec2.sh* en el servidor remoto en EC2, que hará lo siguiente:
    * Actualizar las imágenes de los contenedores en local desde el repositorio de Amazon ECS
    * Parar y levantar de nuevo aquellos contenedores que se hayan actualizado

### Logs

Los logs de todos los servicios se recogen en una ubicación única de la máquina remota en EC2: 

```bash
~/log
```

Para monitorizarlos en tiempo real se puede utilizar el siguiente comando, ejecutado desde la consola de la máquina remota en EC2:

```bash
tail -f ~/log/*/*
```

### Acceso a la consola de los contenedores

Se puede acceder a la consola de cada uno de los contenedores con los siguientes respectivos comandos, ejecutados desde la consola de la máquina remota en EC2:

```bash
docker exec -it $(docker ps -q -f name=nginx) /bin/bash
docker exec -it $(docker ps -q -f name=django) /bin/bash
docker exec -it $(docker ps -q -f name=nodejs) /bin/bash
```

### Dominios, subdominios, DNSs y Hosts

Si se dispone de dominios y subdominios registrados habrá que actualizar los archivos de configuración de NGINX para que atienda las peticiones que vengan hacia esos dominios. Si no disponemos de dominios registrados, podemos cambiar el archivo Hosts para que apunte a la IP pública del servidor de producción, si queremos probarlo. 

