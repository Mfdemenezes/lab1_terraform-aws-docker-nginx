variable "project" {
  description = "Nome do projeto."
  type        = string
  default     = "lab1-terraform-aws-docker-nginx"
}

variable "region" {
  description = "Região AWS."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo da instância EC2."
  type        = string
  default     = "t2.micro"
}

variable "enable_ssh" {
  description = "Se true, abre a porta 22 para SSH."
  type        = bool
  default     = false
}

variable "ssh_ingress_cidr" {
  description = "CIDR permitido para SSH (quando enable_ssh=true)."
  type        = string
  default     = "0.0.0.0/0"
}

# De onde clonar e como buildar
variable "repo_url" {
  description = "URL do repositório Git a ser clonado pela EC2."
  type        = string
  default     = "https://github.com/Mfdemenezes/lab1_terraform-aws-docker-nginx.git"
}

variable "repo_branch" {
  description = "Branch do repositório."
  type        = string
  default     = "main"
}

variable "dockerfile_path" {
  description = "Caminho do Dockerfile relativo à raiz do repo."
  type        = string
  default     = "docker/Dockerfile"
}

variable "image_name" {
  description = "Nome da imagem local que será buildada na EC2."
  type        = string
  default     = "lab1-nginx"
}

variable "tags" {
  description = "Tags padrão."
  type        = map(string)
  default = {
    Owner   = "Mfdemenezes"
    Project = "lab1-terraform-aws-docker-nginx"
  }
}