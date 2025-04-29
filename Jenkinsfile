pipeline {
    agent any

    stages {
        stage('Git checkout') {
            steps {
                // Clone your GitHub repository
                git 'https://github.com/RameshDumala1/Trading-UI.git'
            }
        }

        stage('Install npm prerequisites') {
            steps {
                // Run npm audit, but don't fail the build if it finds vulnerabilities
                sh 'npm audit || echo "Vulnerabilities found, continuing..."'

                // Optionally try to fix vulnerabilities without breaking changes
                sh 'npm audit fix || true'

                // Install dependencies
                sh 'npm install'

                // Build the application
                sh 'npm run build'

                // Start the app using PM2
                sh '''
                    cd build
                    pm2 --name Trading-UI start npm -- start
                '''
            }
        }
    }
}
