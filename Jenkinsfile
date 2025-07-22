pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: ecr-access-sa
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - sleep
    args:
    - "9999999"
  - name: kubectl
    image: bitnami/kubectl:latest
    command:
    - sleep
    args:
    - "9999999"
"""
    }
  }

  environment {
    AWS_ACCOUNT_ID = "020737256003"
    AWS_REGION = "us-east-1"
    ECR_REPO = "eyego"
    IMAGE_TAG = "0.1.${env.BUILD_NUMBER}"
    FULL_IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Build & Push Image to ECR') {
      steps {
        container('kaniko') {
          dir('hello-eyego-app') {
            sh '''
              /kaniko/executor \
                --context `pwd` \
                --dockerfile Dockerfile \
                --destination=${FULL_IMAGE} \
                --cleanup
            '''
          }
        }
      }
    }

    stage('Update Image in Manifests') {
      steps {
        container('kaniko') {
          dir('manifests') {
            sh '''
              sed -i "s|image: .*|image: ${FULL_IMAGE}|" app-deployment.yaml
            '''
          }
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        container('kubectl') {
          dir('manifests') {
            sh 'kubectl apply -f .'
          }
        }
      }
    }
  }
}
