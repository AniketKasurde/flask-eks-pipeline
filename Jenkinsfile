pipeline {
    agent any

    environment {
        AWS_REGION   = "ap-south-1"
        ECR_REPO     = "760022212905.dkr.ecr.ap-south-1.amazonaws.com/flask-eks-pipeline"
        CLUSTER_NAME = "flask-eks-pipeline-cluster"
        IMAGE_TAG    = ""
    }

    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Set Image Tag") {
            steps {
                script {
                    IMAGE_TAG = sh(
                        script: "git rev-parse --short HEAD",
                        returnStdout: true
                    ).trim()
                    echo "Image tag: ${IMAGE_TAG}"
                }
            }
        }

        stage("Run Tests") {
            steps {
                sh """
                    pip3 install -r tests/requirements-test.txt --break-system-packages -q
                    pip3 install -r app/requirements.txt --break-system-packages -q
                    python3 -m pytest tests/ -v
                """
            }
        }

        stage("Build & Push to ECR") {
            steps {
                sh """
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REPO}

                    docker build -t ${ECR_REPO}:${IMAGE_TAG} ./app

                    docker push ${ECR_REPO}:${IMAGE_TAG}
                """
            }
        }

        stage("Deploy to EKS") {
          steps {
            sh """
            aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}

            kubectl apply -f k8s/namespace.yaml

            kubectl apply -f k8s/deployment.yaml

            kubectl set image deployment/flask-app \
                flask-app=${ECR_REPO}:${IMAGE_TAG} \
                -n flask-app

            kubectl apply -f k8s/service.yaml
        """
    }
}

        stage("Verify Rollout") {
            steps {
                sh """
                    kubectl rollout status deployment/flask-app \
                        -n flask-app \
                        --timeout=120s
                """
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed"
        }
        success {
            echo "Pipeline succeeded"
        }
    }
}