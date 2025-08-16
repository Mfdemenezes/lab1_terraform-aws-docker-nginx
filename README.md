# lab_terraform-aws-docker-nginx

flowchart LR
    Dev[Terraform] --> EC2[(AWS EC2)]
    EC2 --> Docker
    Docker --> NGINX
    User((Usuário)) -->|HTTP 80| NGINX
