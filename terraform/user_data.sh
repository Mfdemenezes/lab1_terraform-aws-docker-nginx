terraform/user_data.sh
#!/bin/bash
set -euxo pipefail

# Atualiza e instala Docker
dnf update -y
dnf install -y docker

# (Opcional mas recomendado) SSM Agent - em AL2023 geralmente já vem instalado,
# mas garantimos e ativamos:
dnf install -y amazon-ssm-agent || true
systemctl enable --now amazon-ssm-agent

# Sobe Docker liberando usuario ec2-user
systemctl enable --now docker
usermod -aG docker ec2-user || true

# Conteúdo HTML simples
mkdir -p /opt/nginx/html
cat > /opt/nginx/html/index.html <<'HTML'
<!doctype html>
<html lang="pt-br">
<head><meta charset="utf-8"><title>Lab 1 — Nginx via Docker</title></head>
<body style="font-family: system-ui; margin: 3rem;">
  <h1>🚀 Lab 1 — Terraform + AWS + Docker + Nginx</h1>
  <p>Instância criada com Terraform, Nginx rodando em container Docker. 🎉</p>
</body>
</html>
HTML

# Baixa e roda Nginx em container
docker pull nginx:alpine
docker rm -f web || true
docker run -d --name web \
  --restart unless-stopped \
  -p 80:80 \
  -v /opt/nginx/html:/usr/share/nginx/html:ro \
  nginx:alpine