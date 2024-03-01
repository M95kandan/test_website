pipeline {
    agent { label 'slave-IAC' } // Specify the label of your Jenkins agent

    environment {
        GITHUB_CREDENTIALS = credentials('79939529-52e1-4037-93ed-e7843a722b7f')
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
                            url: 'https://github.com/M95kandan/mk_website.git',
                            credentialsId: GITHUB_CREDENTIALS
                        ]]
                    ])
                }
            }
        }

        // Add more stages as needed (e.g., Build, Test, Deploy)
    }
}
