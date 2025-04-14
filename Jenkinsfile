pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/satya-git07/e-commerce-application.git'
        DOCKER_HUB_USER = 'satyadockerhub07'
        CREDENTIALS_ID = 'docker-credentials'
        GOOGLE_CREDENTIALS = credentials('gcp-key')
        PROJECT_ID = 'lyrical-bus-452711-c5'
        REGION = 'us-west3-c'
        CLUSTER_NAME = 'my-cluster11'
    }

    stages {

        stage('Clone Repo') {
            steps {
                git url: "${REPO_URL}"
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${CREDENTIALS_ID}", passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage('Build & Push Images') {
            steps {
                script {
                    def services = [
                        'load-generator',
                        'frontend-proxy',
                        'currency',
                        'image-provider',
                        'payment',
                        'product',
                        'quote',
                        'frontend',
                        'fraud-detection',
                        'flagd-ui',
                        'email',
                        'recommandation',
                        'shipping',
                        'checkout',
                        'cart',
                        'ad-micro',
                        'ad',
                        'account'
                    ]

                    for (service in services) {
                        def imageName = "${DOCKER_HUB_USER}/${service}:latest3"
                        echo "Building and pushing image: ${imageName}"

                        dir(service) {
                            sh "docker build -t ${imageName} ."
                            sh "docker push ${imageName}"
                        }
                    }
                }
            }
        }

        stage('Deploy to GKE (Optional)') {
            when {
                expression { return fileExists('terraform/main.tf') }
            }
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh '''
                        gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud config set project ${PROJECT_ID}
                        gcloud config set compute/region ${REGION}
                        gcloud container clusters get-credentials ${CLUSTER_NAME}

                        cd terraform
                        terraform init
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}
