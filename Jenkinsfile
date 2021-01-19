pipeline {
    agent any 
    stages {
        stage('Linting') {
            steps {
                // Install hadolint
                echo "BUILDID: ${env.BUILD_NUMBER}"
                echo 'Installing hadolint...'
                sh 'wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64'
                sh 'chmod +x /bin/hadolint'
                sh 'hadolint Dockerfile'
            }
        }

    }
}