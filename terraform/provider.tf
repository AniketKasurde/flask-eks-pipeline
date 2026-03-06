terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  #backend using s3 for 
  backend "s3" {
    bucket       = "flask-eks-pipeline-tfstate"
    key          = "flask-eks-pipeline/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }

}


# Configure the AWS Provider
provider "aws" {
  region = "var.aws_region"
}

