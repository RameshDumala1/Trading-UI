pipeline {
    agent any

    tools {
        nodejs "Node23" // Make sure this matches your Jenkins NodeJS installation name
    }

    environment {
        IMAGE_NAME = 'dumalaramesh/nodejs-trading-ui:latest'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                echo '📦 Installing dependencies...'
                sh 'npm install'
            }
        }

        stage('Build Application') {
            steps {
                echo '🏗️ Building the app...'
                sh 'npm run build'
            }
        }

        stage('Docker Build') {
            steps {
                echo '🐳 Building Docker image...'
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Docker Push') {
            steps {
                echo '📤 Pushing Docker image...'
                withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_TOKEN')]) {
                    sh '''
                        echo "$DOCKER_TOKEN" | docker login -u dumalaramesh --password-stdin
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                echo '🚀 Deploying container...'
                // Add your deployment script here (e.g., Docker run or Kubernetes apply)
            }
        }
    }

    post {
        failure {
            echo '❌ Pipeline failed!'
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
    }
}
