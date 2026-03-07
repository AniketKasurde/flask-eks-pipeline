output "jenkins_public_ip" {
  description = "Jenkins EC2 public IP - access UI at http://<ip>:8080"
  value       = module.jenkins.jenkins_public_ip
}

output "ecr_repository_url" {
  description = "ECR repository URL for pushing Docker images"
  value       = module.ecr.repository_url
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}
