#!/bin/bash
# start microservices on EC2

# remove all dangling images, if they exist
sudo docker rmi -f $(sudo docker images -q -a -f dangling=true)

# retrieve docker login command and do login
aws ecr get-login --region eu-west-1 > docker_aws_login.sh
chmod +x docker_aws_login.sh
sudo ./docker_aws_login.sh

# pull images
sudo docker-compose pull

# start containers
sudo docker-compose up --remove-orphans -d
