pipeline {
    agent any

    environment {
        IMAGE_NAME = 'dumalaramesh/nodejs-trading-ui:latest'
    }

    tools {
        nodejs 'Node18' // Make sure this matches your Jenkins NodeJS config
    }

    stages {
        stage('Install dependencies') {
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

        stage('Docker Build') {
            steps {
                echo '🐳 Building Docker image...'
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Docker Push') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub', url: '') {
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh 'docker run -d -p 3000:3000 $IMAGE_NAME'
            }
        }

        stage('Cleanup') {
            steps {
                sh 'docker system prune -f'
            }
        }
    }

    post {
        failure {
            echo '❌ Pipeline failed.'
        }
        success {
            echo '✅ Pipeline succeeded.'
        }
    }
}
