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
                git branch: 'main', url: "${REPO_URL}"
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
                        'product-catalog',
                        'quote',
                        'frontend',
                        'fraud-detection',
                        'flagd-ui',
                        'email',
                        'recommendation',
                        'shipping',
                        'checkout',
                        'cart',
                        'ad',
                        'accounting'
                    ]

                    def parallelTasks = services.collectEntries { service ->
                        ["${service}": {
                            def imageName = "${DOCKER_HUB_USER}/${service}:latest3"
                            def dockerfilePath = "${env.WORKSPACE}/src/${service}/Dockerfile"
                            echo "🔧 Building and pushing image: ${imageName}"

                            if (fileExists(dockerfilePath)) {
                                dir("src/${service}") {
                                    try {
                                        sh "docker build -t ${imageName} ."
                                        sh "docker push ${imageName}"
                                        echo "✅ Successfully pushed ${imageName}"
                                    } catch (e) {
                                        echo "❌ Failed to build/push ${imageName}: ${e}"
                                    }
                                }
                            } else {
                                echo "⚠️ Skipping ${service} — Dockerfile not found in ${dockerfilePath}"
                            }
                        }]
                    }

                    parallel parallelTasks
                }
            }
        }



stage('Terraform: Apply Infrastructure') {
             steps {
                script {
                    echo 'Applying Terraform configurations to create GCP resources...'
                    // Ensure you're authenticated and have the necessary permissions to create resources
                    withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        // Authenticate with Google Cloud
                        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
        
                        // Set the environment variable for Terraform GCP provider to use
                        sh 'export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS'
        
                        // Change directory to where the Terraform configuration files are located
                        dir('terraform') {
                            // Initialize Terraform
                            sh 'terraform init'
        
                            // Apply Terraform plan to create resources
                            sh 'terraform apply -auto-approve -var="project_id=${PROJECT_ID}" -var="region=${REGION}" -var="cluster_name=${CLUSTER_NAME}"'
                        }
                    }
                }
            }
        }


        stage('Deploy to GKE with Manifests') {
    steps {
        withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
            script {
                sh '''
                    echo "🔐 Authenticating with Google Cloud..."
                    gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                    gcloud config set project ${PROJECT_ID}
                    gcloud config set compute/region ${REGION}
                    gcloud container clusters get-credentials ${CLUSTER_NAME}
                '''
                
                dir('kubernetes') {
                    sh '''
                        echo "🚀 Applying Kubernetes manifests..."
                        kubectl apply -f complete-deploy.yaml

                    '''
                }
            }
        }
    }
}



        

    }
}
