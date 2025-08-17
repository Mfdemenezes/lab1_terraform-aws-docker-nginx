#!/bin/bash
set -xe

dnf update -y
dnf install -y git docker

systemctl enable --now docker
systemctl enable --now amazon-ssm-agent
usermod -aG docker ec2-user

mkdir -p /opt/app/repo/docker
cd /opt/app/repo/docker

# Clona o repositório da variável
git clone --branch ${REPO_BRANCH} --depth 1 ${REPO_URL} repo
cd repo

# Builda e sobe o container
docker build -t ${IMAGE_NAME} -f ${DOCKERFILE_PATH} .
docker rm -f web || true
docker run -d --name web --restart unless-stopped -p 80:80 ${IMAGE_NAME}
