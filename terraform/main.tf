module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "eks" {
  source             = "./modules/eks"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "jenkins" {
  source                   = "./modules/jenkins"
  project_name             = var.project_name
  vpc_id                   = module.networking.vpc_id
  public_subnet_id         = module.networking.public_subnet_ids[0]
  jenkins_instance_profile = module.eks.jenkins_instance_profile
  key_name                 = var.key_name
}
