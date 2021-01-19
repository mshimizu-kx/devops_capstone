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
        stage('Build_Container'){
            steps {
                // Build container
                sh 'docker build --tag kdb-hdb .'
                sh 'docker tag kdb-hdb mshimizukx/kdb-hdb'
                sh 'docker login'
                sh 'docker push mshimizukx/kdb-hdb'
            }
        }
        stage('Deploy_Infrastructure') {
            steps {
                // Move to directory where cloudformation code is placed
                echo 'Deploy infrastructure.'
                sh script:'''
                  #!/bin/bash
                  cd IAC
                  ./launch_eks.sh
                  cd ..
                '''
            }
        }
        stage('Deploy_Application') {
            steps {
                // Move to directory where manifest is placed
                echo 'Deploy application.'
                sh script:'''
                  #!/bin/bash
                  cd manifest
                  ./deploy_app.sh
                  cd ..
                '''
            }
        }
        stage('Run Smoke Test') {
            steps {
                // Move to directory where test script is placed
                echo 'Run smoke test'
                sh script:'''
                  #!/bin/bash
                  cd userscript
                  ./smoke_test
                  cd ..
                '''
            }
        }
        stage('Clean up') {
            steps {
                // Delete previous stack
                echo 'Clean up previous cluster.'
                sh script:'''
                  #!/bin/bash
                  cd IAC
                  ./clean_up_old_eks.sh 
                  cd ..
                '''
            }
        }
    }
}