#!/bin/bash
set -euxo pipefail

# Variáveis injetadas pelo Terraform
REPO_URL="${REPO_URL}"
REPO_BRANCH="${REPO_BRANCH}"
DOCKERFILE_PATH="${DOCKERFILE_PATH}"
IMAGE_NAME="${IMAGE_NAME}"

# Atualiza sistema e instala pacotes
dnf update -y
dnf install -y git docker
dnf install -y amazon-ssm-agent || true
systemctl enable --now amazon-ssm-agent

# Inicia Docker
systemctl enable --now docker
usermod -aG docker ec2-user || true

# Clona repositório
install -d -m 0755 /opt/app
cd /opt/app
if [ ! -d repo ]; then
  git clone --branch "${REPO_BRANCH}" --depth 1 "${REPO_URL}" repo
fi
cd repo

# Build da imagem (contexto = raiz do repositório)
docker build -t "${IMAGE_NAME}" -f "${DOCKERFILE_PATH}" .

# Sobe o container
docker rm -f web || true
docker run -d --name web \
  --restart unless-stopped \
  -p 80:80 \
  "${IMAGE_NAME}"
