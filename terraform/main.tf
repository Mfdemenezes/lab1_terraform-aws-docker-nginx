locals {
  name      = var.project
  subnet_id = data.aws_subnets.default.ids[0]
}

# AMI Amazon Linux 2023 (x86_64) via SSM
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Default VPC and subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group (HTTP open; optional SSH)
resource "aws_security_group" "web" {
  name        = "${local.name}-sg"
  description = "SG for HTTP (optional SSH)"
  vpc_id      = data.aws_vpc.default.id
  tags        = merge(var.tags, { Name = "${local.name}-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "HTTP"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  count             = var.enable_ssh ? 1 : 0
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = var.ssh_ingress_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "SSH optional"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "All outbound"
}

# IAM for SSM (Session Manager)
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm" {
  name               = "${local.name}-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  tags               = merge(var.tags, { Name = "${local.name}-ssm-role" })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm" {
  name = "${local.name}-ssm-profile"
  role = aws_iam_role.ssm.name
}

# EC2 instance (build & run your Docker image on boot)
resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id
  associate_public_ip_address = true

  # Root disk (EBS)
  root_block_device {
    volume_size = 12
    volume_type = "gp3"
  }

  iam_instance_profile   = aws_iam_instance_profile.ssm.name
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    REPO_URL        = var.repo_url
    REPO_BRANCH     = var.repo_branch
    DOCKERFILE_PATH = var.dockerfile_path
    IMAGE_NAME      = var.image_name
  })
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(var.tags, { Name = "${local.name}-ec2" })
}

# Elastic IP always attached to the instance
resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"
  tags     = merge(var.tags, { Name = "${local.name}-eip" })
}
