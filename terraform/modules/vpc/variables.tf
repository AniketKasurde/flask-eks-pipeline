variable "project_name" {
  description = "name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for vpc"
  type        = string
  default     = "10.0.0.0/16"
}
