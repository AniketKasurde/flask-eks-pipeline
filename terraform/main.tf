module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "jenkins" {
  source           = "./modules/jenkins"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
  key_name         = var.key_name
}

module "eks" {
  source                    = "./modules/eks"
  project_name              = var.project_name
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.private_subnet_ids
  public_subnet_ids         = module.vpc.public_subnet_ids
  jenkins_role_arn          = module.jenkins.jenkins_role_arn
  jenkins_security_group_id = module.jenkins.jenkins_security_group_id
}
