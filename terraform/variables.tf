variable "project_name" {
  description = "name of the project"
  type        = string
  default     = "flask-eks-pipeline"
}

variable "key_name" {
  description = "Jenkins EC2 key"
  type        = string
}
