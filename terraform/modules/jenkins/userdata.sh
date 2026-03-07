#!/bin/bash
set -ex

exec > >(tee /var/log/user-data.log) 2>&1

echo "========== Starting user data script =========="

# Update system
apt-get update -y
apt-get install -y curl unzip openjdk-21-jre fontconfig wget python3 python3-pip

# Install Jenkins
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update -y
apt-get install -y jenkins
systemctl enable jenkins
systemctl start jenkins

# Install Docker
echo "Installing Docker..."
apt-get install -y docker.io
systemctl enable docker
systemctl start docker
usermod -aG docker jenkins

# Install AWS CLI
echo "Installing AWS CLI..."
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install --update
rm -rf awscliv2.zip ./aws

# Install kubectl
echo "Installing kubectl..."
K8S_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Setup kubeconfig directory for jenkins user
mkdir -p /var/lib/jenkins/.kube
chown jenkins:jenkins /var/lib/jenkins/.kube

# Restart Jenkins to pick up docker group membership
systemctl restart jenkins

echo "========== User data script complete =========="