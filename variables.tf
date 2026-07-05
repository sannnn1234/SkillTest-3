# variables.tf
# Input variables. All have sensible defaults so `terraform apply` works
# out of the box; override any of them via -var or a .tfvars file.

variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix used for tagging and naming resources."
  type        = string
  default     = "terraform-nginx-ubuntu"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair for SSH access. Leave empty to launch without a key."
  type        = string
  default     = ""
}

variable "ssh_cidr" {
  description = "CIDR block allowed to connect over SSH (port 22). Restrict to your own IP for better security."
  type        = string
  default     = "0.0.0.0/0"
}
