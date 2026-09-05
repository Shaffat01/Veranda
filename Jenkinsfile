pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Pulling Veranda Project from GitHub...'
                checkout scm
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                echo '🐳 Building Docker Image and Starting Container on Port 8082...'
                sh '''
                    # Old container stop and remove
                    docker compose down || true

                    # Build new docker image and start container
                    docker compose up -d --build
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo '🌐 Testing Container Health on Port 8082...'
                sh '''
                    sleep 3
                    docker ps | grep veranda-web-container
                    curl -sI http://localhost:8082 | head -n 1
                '''
            }
        }
    }

    post {
        success {
            echo '🎉 Veranda Website is running in Docker Container on Port 8082!'
        }
        failure {
            echo '❌ Docker Deployment failed!'
        }
    }
}
