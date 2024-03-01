pipeline {
    agent { label 'slave-IAC' }
    
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Clone the repository
                    sh 'git clone https://github.com/M95kandan/mk_website.git'
                }
            }
        }

        stage('Build Infrastructure') {
            steps {
                script {
                    // Change to the directory containing terraform.tf
                    dir('mk_website') {
                        // Execute Terraform commands
                        sh 'sudo terraform init'
                        sh 'sudo terraform plan'
                    }
                }
            }
        }
    }
}
