variable "project_name" {
  description = "Project name used to prefix all resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where Jenkins EC2 will be created"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID where Jenkins EC2 will be created"
  type        = string
}

variable "key_name" {
  description = "Name of existing AWS key pair for Jenkins EC2"
  type        = string
}
