# lab_terraform-aws-docker-nginx

Objetivo: Provisionar EC2 com Terraform, instalar Docker via user_data e subir NGINX.

Adicionar no terraform-aws-docker-nginx/README.md (seção “Arquitetura”):

flowchart LR
    Dev[Terraform] --> EC2[(AWS EC2)]
    EC2 --> Docker
    Docker --> NGINX
    User((Usuário)) -->|HTTP 80| NGINX
