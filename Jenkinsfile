pipeline {
    agent any
    environment {
        WORKFLOW_ID = "${env.BUILD_NUMBER}"
    }
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
        stage('Deploy_Infrastructure') {
            steps {
                // Move to directory where cloudformation code is placed
                sh 'cd IAC'
                echo 'Deploy infrastructure.'
                sh './launch_eks.sh'
                sh 'cd ..'
            }
        }
        stage('Deploy_Application') {
            steps {
                // Move to directory where manifest is placed
                sh 'cd manifest'
                echo 'Deploy application.'
                sh './deploy_app.sh'
                sh 'cd ..'
            }
        }
        stage('Run Smoke Test') {
            steps {
                // Move to directory where test script is placed
                sh 'cd userscript'
                echo 'Run smoke test'
                sh './smoke_test'
                sh 'cd ..'
            }
        }
        stage('Clean up') {
            steps {
                // Delete previous stack
                echo 'Clean up previous cluster.'

            }
        }
    }
}