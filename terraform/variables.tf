variable "project" {
  description = "Project name."
  type        = string
  default     = "lab1-terraform-aws-docker-nginx"
}

variable "region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "enable_ssh" {
  description = "If true, opens port 22 for SSH."
  type        = bool
  default     = false
}

variable "ssh_ingress_cidr" {
  description = "CIDR allowed for SSH when enable_ssh=true."
  type        = string
  default     = "0.0.0.0/0"
}

# Repo -> build -> run
variable "repo_url" {
  description = "Git repository URL to clone on EC2."
  type        = string
  default     = "https://github.com/Mfdemenezes/lab1_terraform-aws-docker-nginx.git"
}

variable "repo_branch" {
  description = "Repository branch."
  type        = string
  default     = "main"
}

variable "dockerfile_path" {
  description = "Dockerfile path relative to repo root."
  type        = string
  default     = "docker/Dockerfile"
}

variable "image_name" {
  description = "Local image name to build on EC2."
  type        = string
  default     = "lab1-nginx"
}

variable "tags" {
  description = "Default resource tags."
  type        = map(string)
  default = {
    Owner   = "Mfdemenezes"
    Project = "lab1-terraform-aws-docker-nginx"
  }
}
