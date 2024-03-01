pipeline {
    agent { label 'slave-IAC' } // Specify the label of your Jenkins agent

    environment {
        GITHUB_CREDENTIALS = credentials('github_token')
        BRANCH_NAME = 'main' // Replace with your desired branch name
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout code from GitHub repository with authentication
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "*/${BRANCH_NAME}"]],
                        userRemoteConfigs: [[
                            url: 'https://github.com/M95kandan/test_website.git',
                            credentialsId: GITHUB_CREDENTIALS
                        ]]
                    ])
                }
            }
        }

        // Add more stages as needed (e.g., Build, Test, Deploy)
    }
}
