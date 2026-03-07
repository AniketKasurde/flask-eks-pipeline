variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "name of the project"
  type        = string
  default     = "flask-eks-pipeline"
}

variable "key_name" {
  description = "Jenkins EC2 key"
  type        = string
}
