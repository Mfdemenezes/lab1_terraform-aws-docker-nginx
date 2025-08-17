# Lab 1 — Terraform + AWS + Docker + Nginx

Este laboratório provisiona infraestrutura AWS com Terraform e roda um container Nginx via Docker.

## Estrutura

- `terraform/` — códigos IaC para provisionar rede/EC2/security groups
- `docker/` — Dockerfile e recursos do container
- `nginx/` — configs do Nginx (ex.: `default.conf`)

## Pré-requisitos

- Git + chave SSH configurada no GitHub
- Terraform >= 1.6
- AWS CLI configurado (`aws configure`)
- Docker instalado

## Próximos passos

1. Completar os arquivos Terraform (VPC/Security Group/EC2).
2. Criar Dockerfile e publicar imagem (opcional) ou build local.
3. Subir Nginx e validar página de boas-vindas.
