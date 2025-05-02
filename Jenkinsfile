pipeline {
    agent any

    tools {
        nodejs 'Node23'  // Ensure this matches your Global Tool Configuration
    }

    environment {
        IMAGE_NAME = 'dumalaramesh/nodejs-trading-ui:latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Checking out source code...'
                git 'https://github.com/betawins/docker-tasks.git'
            }
        }
        stage('Install Node.js and npm (Amazon Linux / RHEL)') {
            steps {
                sh '''
                    curl -fsSL https://rpm.nodesource.com/setup_${NODE_VERSION} | sudo bash -
                    sudo yum install -y nodejs
                '''
            }
        }
        stage('Install dependencies & build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Run with PM2') {
            steps {
                sh '''
                    sudo npm install -g pm2
                    pm2 start app.js || true
                '''
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
