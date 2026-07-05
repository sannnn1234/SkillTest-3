# main.tf
# Provisions a t2.micro Ubuntu 20.04 EC2 instance in the default VPC,
# running Nginx with a custom index page, secured by a security group
# that allows inbound HTTP (80) and SSH (22).

# ---------------------------------------------------------------------------
# Terraform & provider versions
# ---------------------------------------------------------------------------
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---------------------------------------------------------------------------
# AWS provider & region
# ---------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region
}

# ---------------------------------------------------------------------------
# Look up the default VPC (we do NOT create one, per the requirements)
# ---------------------------------------------------------------------------
data "aws_vpc" "default" {
  default = true
}

# ---------------------------------------------------------------------------
# Look up the latest official Ubuntu 20.04 LTS (Focal) AMI from Canonical.
# Using a data source keeps the config region-agnostic (no hard-coded AMI ID).
# ---------------------------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ---------------------------------------------------------------------------
# Security group: allow inbound HTTP (80) and SSH (22), all outbound.
# Created inside the default VPC.
# ---------------------------------------------------------------------------
resource "aws_security_group" "nginx" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg"
    Project = var.project_name
  }
}

# ---------------------------------------------------------------------------
# EC2 instance: t2.micro Ubuntu 20.04, bootstrapped with Nginx via user_data.
# ---------------------------------------------------------------------------
resource "aws_instance" "nginx" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name != "" ? var.key_name : null
  vpc_security_group_ids = [aws_security_group.nginx.id]

  # Install Nginx and replace the default index page with a custom one.
  user_data = <<-EOF
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get install -y nginx
    echo "Welcome to the Terraform-managed Nginx Server on Ubuntu" > /var/www/html/index.html
    systemctl enable nginx
    systemctl restart nginx
  EOF

  tags = {
    Name    = "${var.project_name}-instance"
    Project = var.project_name
  }
}
