#seccurity group for Jenkins EC2
resource "aws_security_group" "jenkins" {
  name        = "${var.project_name}-jenkins-sg"
  description = "Security group for Jenkins EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-jenkins-sg"
  }
}

#Jenkins EC2
resource "aws_instance" "jenkins" {
  ami                    = ami-019715e0d74f695be
  instance_type          = t3.small
  subnet_id              = var.public_subnet_id
  key_name               = "ci-cd-key"
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  iam_instance_profile   = var.jenkins_instance_profile

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "${var.project_name}-jenkins"
  }

}
