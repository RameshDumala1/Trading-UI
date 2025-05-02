pipeline {
    agent any

    tools {
        nodejs 'Node23'  // Ensure this matches your Global Tool Configuration
    }

    environment {
        IMAGE_NAME = 'rameshtrader/nodejs-trading-ui:latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Checking out source code...'
                git 'https://github.com/betawins/docker-tasks.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo '📦 Installing Node.js dependencies...'
                dir('trading-ui') {
                    sh 'npm install'
                    sh 'npm install bootstrap'
                    sh 'npm install react-router-dom'
                }
            }
        }

        stage('Build App') {
            steps {
                echo '🏗️ Building React App...'
                dir('trading-ui') {
                    sh 'npm run build'
                }
            }
        }

        stage('Docker Build') {
            steps {
                echo '🐳 Building Docker image...'
                dir('trading-ui') {
                    sh 'docker build -t $IMAGE_NAME .'
                }
            }
        }

        stage('Docker Push') {
            steps {
                echo '📤 Pushing Docker image to DockerHub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                echo '🚀 Running Docker container...'
                sh 'docker rm -f trading-ui || true'
                sh 'docker run -d --name trading-ui -p 3000:3000 $IMAGE_NAME'
            }
        }

        stage('Cleanup') {
            steps {
                echo '🧹 Cleaning up workspace...'
                cleanWs()
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
