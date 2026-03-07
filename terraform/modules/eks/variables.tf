variable "project_name" {
  description = "name of the project"
  type        = string
  default     = "flask-eks-pipeline"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where EKS worker nodes will run"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be created"
  type        = string
}
