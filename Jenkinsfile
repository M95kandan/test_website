pipeline {
    agent { label 'slave-IAC' }
    
    environment {
        GITHUB_REPO_URL = "https://github.com/M95kandan/mk_website.git"
        DOCKERHUB_USERNAME = "m95kandan"
        DOCKERHUB_PASSWORD = "M#95kandan"
        DOCKERHUB_REPOSITORY = "m95kandan/website"
        BUILD_NUMBER_TAG = "${BUILD_NUMBER}"
        RETRY_COUNT = 3
        RETRY_INTERVAL = 60  // seconds
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Clone the repository
                    git branch: 'main', url: 'https://github.com/M95kandan/mk_website.git'
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    retry(RETRY_COUNT) {
                       
                            ansiblePlaybook(
                                playbook: 'docker_build.yml',
                                inventory: 'inventory',
                                extraVars: [
                                    github_repo_url: GITHUB_REPO_URL,
                                    dockerhub_username: DOCKERHUB_USERNAME,
                                    dockerhub_password: DOCKERHUB_PASSWORD,
                                    dockerhub_repository: DOCKERHUB_REPOSITORY,
                                    build_number_tag: BUILD_NUMBER_TAG
                                ]
                            )
                        }
                    
                }
            }
        }
    }
}
