pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'rameshdumala/trading-ui'
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/RameshDumala1/Trading-UI.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    echo "Installing Node.js and dependencies..."
                    sudo dnf install -y nodejs || true
                    npm install
                    npm install bootstrap
                '''
            }
        }

        stage('Build App') {
            steps {
                sh '''
                    echo "Building React App..."
                    npm run build
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "Building Docker Image..."
                    docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_HUB_PASSWORD')]) {
                    sh '''
                        echo "$DOCKER_HUB_PASSWORD" | docker login -u rameshdumala --password-stdin
                        docker push $DOCKER_IMAGE:$DOCKER_TAG
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    echo "Deploying Docker Container..."
                    docker stop trading-ui || true
                    docker rm trading-ui || true
                    docker run -d --name trading-ui -p 3000:3000 $DOCKER_IMAGE:$DOCKER_TAG
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
        failure {
            echo '❌ Pipeline failed.'
        }
        success {
            echo '✅ Pipeline succeeded.'
        }
    }
}
