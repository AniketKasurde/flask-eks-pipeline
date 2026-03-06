output "repository_url" {
  description = "ECR repository URL for pushing and pulling images"
  value       = aws_ecr_repository.app.repository_url
}
