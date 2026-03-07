variable "project_name" {
  description = "Project name used to prefix all resources"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where EKS worker nodes will run"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for EKS control plane"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be created"
  type        = string
}

variable "jenkins_role_arn" {
  description = "Jenkins IAM role ARN for EKS access entry"
  type        = string
}

variable "jenkins_security_group_id" {
  description = "Jenkins security group ID to allow EKS API access"
  type        = string
}
