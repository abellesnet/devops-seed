#!/usr/bin/env bash
# deploy a new release on Amazon EC2 Ubuntu instance

# Set aws credentials
# aws configure

if [ $# -ne 5 ]
then
    echo "Tags missing"
    echo
    echo "Usage:"
    echo "./deploy_aws.sh containers_repos_domain remote_server_access nginx_tag django_tag nodejs_tag"
    echo
    echo "Example:"
    echo "./deploy_aws.sh 123456789012.abc.ecr.eu-west-1.amazonaws.com ubuntu@1.2.3.4 2.1 1.0 1.2"
    echo
else

    echo "Deploying:"
    echo "nginx $3 version"
    echo "django $4 version"
    echo "nodejs $5 version"
    echo

    # retrieve docker login command and do login
    aws ecr get-login --region eu-west-1 > docker_aws_login.sh
    source docker_aws_login.sh

    docker build ./nginx --force-rm --pull -t devops/nginx:$3
    docker build ./django --force-rm --pull -t devops/django:$4
    docker build ./nodejs --force-rm --pull -t devops/nodejs:$5

    docker tag devops/nginx:$3 $1/devops/nginx:$3
    docker tag devops/django:$4 $1/devops/django:$4
    docker tag devops/nodejs:$5 $1/devops/nodejs:$5

    docker push $1/devops/nginx:$3
    docker push $1/devops/django:$4
    docker push $1/devops/nodejs:$5

    cp docker-compose.prod.template.yml docker-compose.prod.yml

    sed -i '' -e "s/containers_repos_domain/$1/g" docker-compose.prod.yml
    sed -i '' -e "s/:nginx_tag/:$3/g" docker-compose.prod.yml
    sed -i '' -e "s/:django_tag/:$4/g" docker-compose.prod.yml
    sed -i '' -e "s/:nodejs_tag/:$5/g" docker-compose.prod.yml

    scp -i "credentials.pem" docker-compose.prod.yml $2:/home/ubuntu/docker-compose.yml
    scp -i "credentials.pem" start_services_ec2.sh $2:/home/ubuntu

fi
