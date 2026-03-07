variable "project_name" {
  description = "name of the project"
  type        = string
}

variable "vpc_id" {
  description = "vpc ID where Jenkins EC2 will be created"
  type        = string
}

variable "public_subnet_id" {
  description = "public subnet ID where Jenkins EC2 will be created"
}

variable "jenkins_instance_profile" {
  description = "IAM instance profile name to attach to Jenkins EC2"
  type        = string
}

variable "key_name" {
  description = "Jenkins EC2 key"
  type        = string

}
