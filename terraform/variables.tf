#########################################
# Variables Terraform
#########################################

# Projeto
variable "project" {
  description = "Nome do projeto"
  type        = string
  default     = "lab1"
}

# Tipo da instância EC2
variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}

# Tags padrão
variable "tags" {
  description = "Tags adicionais"
  type        = map(string)
  default = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# Libera SSH? (true/false)
variable "enable_ssh" {
  description = "Se true, libera porta 22 para SSH"
  type        = bool
  default     = false
}

# CIDR de origem para SSH
variable "ssh_ingress_cidr" {
  description = "CIDR para acesso SSH (se enable_ssh=true)"
  type        = string
  default     = "0.0.0.0/0"
}

# URL do repositório Git
variable "repo_url" {
  description = "URL do repositório Git"
  type        = string
  default     = "https://github.com/Mfdemenezes/lab1_terraform-aws-docker-nginx.git"
}

# Branch do repositório
variable "repo_branch" {
  description = "Branch do repositório"
  type        = string
  default     = "main"
}

# Caminho do Dockerfile dentro do repositório
variable "dockerfile_path" {
  description = "Caminho do Dockerfile dentro do repositório"
  type        = string
  default     = "docker/Dockerfile"
}

# Nome da imagem Docker
variable "image_name" {
  description = "Nome da imagem Docker a ser construída"
  type        = string
  default     = "lab1-nginx"
}
