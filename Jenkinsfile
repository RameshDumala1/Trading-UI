pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "dumalaramesh/trading-ui:${BUILD_NUMBER}"
        DOCKER_CREDENTIALS = 'docker-hub-credentials'
    }

    stages {
        stage('Git Clone') {
            steps {
                git url: 'https://github.com/RameshDumala1/Trading-UI.git', branch: 'master'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    # Install Node.js and npm on Amazon Linux 2023
                    sudo dnf install -y nodejs
                    node -v
                    npm -v
                    npm install
                '''
            }
        }

        stage('Build App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: "$DOCKER_CREDENTIALS", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f trading-ui || true
                    docker run -d --name trading-ui --restart always -p 3000:3000 $DOCKER_IMAGE
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh 'docker image prune -f'
            }
        }
    }

    post {
        success {
            echo '✅ CI/CD pipeline completed successfully.'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
