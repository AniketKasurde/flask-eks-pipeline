output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "jenkins_instance_profile" {
  description = "IAM instance profile name for Jenkins EC2"
  value       = aws_iam_instance_profile.jenkins.name
}
