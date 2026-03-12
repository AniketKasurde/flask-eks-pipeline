# Flask EKS Pipeline

An end-to-end CI/CD pipeline that automatically tests, builds, and deploys a containerised Flask application to AWS EKS using Jenkins, Docker, ECR, and Terraform.

---

## What this project does

Every time code is pushed to the main branch, Jenkins automatically runs tests, builds a Docker image, pushes it to AWS ECR, and deploys it to an EKS cluster. The whole thing runs without any manual steps.

---

## Architecture

```
Push to GitHub
      ↓
GitHub Webhook triggers Jenkins
      ↓
CI: Run tests → Build image → Push to ECR
      ↓
CD: Deploy to EKS → Verify rollout
      ↓
App live on AWS LoadBalancer
```

## Tech Stack

| Tool         | Purpose                                      |
| ------------ | -------------------------------------------- |
| AWS EKS      | Kubernetes cluster that runs the application |
| AWS ECR      | Private container registry for Docker images |
| Jenkins      | CI/CD automation server                      |
| Docker       | Containerises the Flask application          |
| Terraform    | Provisions all AWS infrastructure as code    |
| Kubernetes   | Orchestrates and manages application pods    |
| GitHub       | Source control and webhook trigger           |
| Python/Flask | Simple web application being deployed        |

---

## Infrastructure

Everything is provisioned with Terraform, split into four modules:

- **vpc** — VPC, public and private subnets across 2 AZs, NAT Gateway
- **eks** — EKS cluster with worker nodes in private subnets
- **jenkins** — EC2 in public subnet with IAM role scoped to ECR and EKS
- **ecr** — Container registry with lifecycle policy to keep last 10 images

Terraform state is stored in S3 with native state locking.

---

## CI/CD Pipeline

The Jenkins pipeline is triggered automatically on every push to the `main` branch via GitHub webhook.

### CI Stage

1. Checkout code from GitHub
2. Set image tag using git commit SHA for traceability
3. Run pytest unit tests — pipeline stops if tests fail
4. Build Docker image tagged with git SHA
5. Push image to Amazon ECR

### CD Stage

6. Update kubeconfig to authenticate with EKS cluster
7. Apply Kubernetes manifests (namespace, deployment, service)
8. Update running deployment with new image using `kubectl set image`
9. Verify rollout succeeded using `kubectl rollout status`

---

## Kubernetes Setup

The application runs in a dedicated `flask-app` namespace with:

- **2 replicas** for basic high availability
- **Resource limits** — CPU and memory limits on every container
- **Readiness probe** — Kubernetes waits for app to be ready before sending traffic
- **Liveness probe** — Kubernetes automatically restarts unhealthy pods
- **LoadBalancer Service** — AWS ELB provisioned automatically for public access

---

## Key Design Decisions

**Git SHA image tagging** — every image is tagged with the git commit SHA instead of `latest`. This ensures full traceability and enables rollback to any previous version.

**Private subnets for workers** — EKS worker nodes run in private subnets with no public IPs. All outbound traffic routes through a NAT Gateway. Jenkins reaches the EKS API privately via a security group rule.

**Modular Terraform** — infrastructure is split into four modules (vpc, eks, jenkins, ecr) with clear separation of concerns. Each module has one responsibility.

**Test gate** — the pipeline stops at the test stage if pytest fails. Broken code never reaches ECR or EKS.

**S3 native state locking** — Terraform state is stored in S3 with native locking.

---

## How to Run

### Prerequisites

- AWS CLI configured
- Terraform
- Existing AWS key pair

### 1. Create S3 bucket for Terraform state from AWS console

### 2. Provision infrastructure

```bash
cd terraform
terraform init
terraform apply
```

### 3. Access Jenkins

```
http://<jenkins_public_ip>:8080
```

### 4. Configure Jenkins pipeline

- Create a new Pipeline job
- Set pipeline definition to Pipeline script from SCM
- Point to this repository
- Add GitHub webhook pointing to Jenkins

### 5. Push code to trigger pipeline

```bash
git push origin main
```

---

## Lessons Learned

- Jenkins runs pipeline stages as the `jenkins` user — kubeconfig directory must exist at `/var/lib/jenkins/.kube`
- DynamoDB state locking is deprecated — S3 native locking is the current standard
- With both public and private endpoints enabled, AWS split-horizon DNS 
   resolves the EKS API to a private IP that Jenkins couldn't reach — 
   required a dedicated security group rule allowing Jenkins to reach the 
   EKS cluster on port 443

---

## Author

**Aniket Kasurde**
[GitHub](https://github.com/AniketKasurde) | [LinkedIn](https://www.linkedin.com/in/aniket-kasurde/)
