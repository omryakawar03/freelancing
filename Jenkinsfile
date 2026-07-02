pipeline {
    agent any
    parameters {
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Docker Hub image tag to deploy')
    }
    environment {
        AWS_REGION = 'ap-south-1'
        CLUSTER_NAME = 'zero-downtime-cluster'
    }
    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Configure kubectl') {
            steps {
                sh "aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${AWS_REGION}"
            }
        }
        stage('Deploy to Staging') {
            steps {
                sh """
                  helm upgrade --install app ./helm-chart/app -n staging \
                    -f ./helm-chart/app/values-staging.yaml \
                    --set image.tag=${params.IMAGE_TAG}
                """
            }
        }
        stage('Smoke Test') {
            steps {
                sh """
                  sleep 15
                  kubectl run smoke-test --rm -i --restart=Never -n staging \
                    --image=curlimages/curl -- curl -sf http://app:5000/healthz
                """
            }
        }
        stage('Approval') {
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'
            }
        }
        stage('Deploy to Production') {
            steps {
                sh """
                  helm upgrade --install app ./helm-chart/app -n production \
                    -f ./helm-chart/app/values-prod.yaml \
                    --set image.tag=${params.IMAGE_TAG}
                """
            }
        }
    }
    post {
        failure {
            sh "helm rollback app -n production || true"
        }
    }
}