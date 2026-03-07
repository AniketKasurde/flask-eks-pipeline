output "jenkins_public_ip" {
  description = "Public IP of Jenkins EC2"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_instance_profile" {
  description = "Jenkins IAM instance profile name"
  value       = aws_iam_instance_profile.jenkins.name
}

output "jenkins_role_arn" {
  description = "Jenkins IAM role ARN for EKS access entry"
  value       = aws_iam_role.jenkins.arn
}

output "jenkins_security_group_id" {
  description = "Jenkins security group ID"
  value       = aws_security_group.jenkins.id
}
