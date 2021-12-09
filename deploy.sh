#!/bin/bash

docker rm $(docker ps -a -q)

docker rmi $(docker images)

#Create network
docker network create my-trio-task-network 


#Create volume
docker volume create trio-db-volume

#Building images
docker build -t my-sql-img db
docker build -t trio-task-img flask-app

#run db container
docker run -d  --network my-trio-task-network  --volume trio-db-volume:/var/lib/mysql --name mysql my-sql-img  
#run flask app
docker run -d  --network my-trio-task-network --name flask-app  trio-task-img
#run nginx container
docker run -d --network my-trio-task-network -p 80:80 --name nginx_container --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf nginx
