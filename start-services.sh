#!/bin/bash

# remove old project containers, if they exist
docker rm -f $(docker ps -q -a -f name=devops)

# remove all dangling images, if they exist
docker rmi -f $(docker images -q -a -f dangling=true)

# build images
docker-compose build

# start containers
docker-compose up
