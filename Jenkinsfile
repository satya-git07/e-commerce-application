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

       stage("Creating the Cluster") {
    steps {
        withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
            dir('terraform') {
                sh '''
                    echo "🔐 Activating service account..."
                    gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

                    echo "🔧 Setting GCP project and region..."
                    gcloud config set project ${PROJECT_ID}
                    gcloud config set compute/region ${REGION}

                    echo "📦 Initializing Terraform..."
                    terraform init

                    echo "🚀 Applying Terraform to create GKE cluster..."
                    terraform apply -auto-approve
                '''
            }
        }
    }
}

    }
}
