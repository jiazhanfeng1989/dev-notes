---
id: 2pqr9mpo11lcwdos4mxx4nj
title: Docker
desc: ''
updated: 1764832044620
created: 1760420405986
---

# Description
[Docker](https://www.docker.com/) is a platform for developing, shipping, and running applications in containers.

# Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker Practice](https://vuepress.mirror.docker-practice.com/)

# Commands
```bash
# Image
docker pull <image> # pull an image from a registry
docker build -t <image>. # build an image from a Dockerfile
docker run -it <image> /bin/bash # run a container from an image
docker run -d -p 8080:80 -v/host/path:/container/path <image> # run a container from an image with a volume
docker rmi <image> # remove an image
docker images # list all images
docker inspect <image> # inspect an image
docker image prune -a # remove unused images

# Container
docker ps # list running containers
docker ps -a # list all containers
docker exec -it <container> bash # execute a command in a container
docker cp <container>:/app/logs/output.log . # copy a file from a container to the host
docker stop <container_id> # stop a container
docker rm -f <container_id> # force remove a container
docker logs -f <container_id> # follow the logs of a container
docker container prune # remove all stopped containers
docker rm -f $(docker ps -a -q --filter ancestor=<image>) # remove all containers with a specific image
docker ps -a --filter ancestor=<image> # list all containers with specific images
docker run -it --rm -v ~/.ssh:/root/.ssh <container_id> /bin/bash # run a container from an image with ssh shared
docker run -it -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent <image> bash # run container with ssh shared

# Docker Compose
docker compose up -d # start a container from a docker-compose.yml file
docker compose down # stop and remove a container from a docker-compose.yml file
docker compose logs -f # follow the logs of a container from a docker-compose.yml file

# Docker Network
docker network ls # list all networks
docker network prune # remove all unused networks

# Docker Volume
docker volume ls # list all volumes
docker volume create mydata # create a volume
docker volume prune # remove all unused volumes

# Docker System
docker system prune -a # remove all unused containers, images, volumes, and networks

# Docker Stats
docker stats # show resource usage statistics for all running containers
```

