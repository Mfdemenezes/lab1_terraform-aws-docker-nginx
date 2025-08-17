#!/bin/bash
set -euxo pipefail

# Atualiza pacotes
dnf update -y

# Instala Docker e Git
dnf install -y docker git

# Inicia e habilita Docker
systemctl enable docker
systemctl start docker

# Adiciona ec2-user ao grupo docker
usermod -aG docker ec2-user

# Clona o repositório (HTTPS para evitar chave SSH)
rm -rf /opt/app
mkdir -p /opt/app
git clone --branch ${REPO_BRANCH} --depth 1 ${REPO_URL} /opt/app/repo

# Faz build da imagem a partir do Dockerfile dentro da pasta docker
cd /opt/app/repo
docker build -t ${IMAGE_NAME} -f ${DOCKERFILE_PATH} .

# Remove container antigo se existir
docker rm -f web || true

# Sobe o container na porta 80
docker run -d --name web --restart unless-stopped -p 80:80 ${IMAGE_NAME}
