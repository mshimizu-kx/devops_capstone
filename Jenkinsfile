pipeline {
    agent any 
    stages {
        stage('Linting') {
            steps {
                # Install hadolint
                echo -n "Installing hadolint..."
                wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64 && chmod +x /bin/hadolint
                if [[ $? -ne 0 ]]; then
                  echo -e "\e[31mfail\e[0m"
                  exit 1
                else
                  echo -e "\e[32mok\e[0m"
                fi
                hadolint Dockerfile
            }
        }
        stage('Deploy_Infrastructure') {
            steps {
                # Move to directory where cloudformation code is placed
                cd IAC
                echo "Deploy infrastructure."
                ./launch_eks.sh
                cd ..
            }
        }
        stage('Deploy_Application') {
            steps {
                # Move to directory where manifest is placed
                cd manifest
                echo "Deploy application."
                ./deploy_app.sh
                cd ..
            }
        }
        stage('Run Smoke Test') {
            steps {
                # Move to directory where test script is placed
                cd userscript
                echo "Run smoke test"
                ./smoke_test
                cd ..
            }
        }
        stage('Clean up') {
            steps {
                echo "Clean up previous cluster."
            }
        }
    }
}