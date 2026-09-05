pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Pulling latest code from GitHub...'
                checkout scm
            }
        }

        stage('Build & Deploy with Docker Compose') {
            steps {
                echo '🐳 Building Docker Image and Starting Container on Port 8082...'
                sh '''
                    # পুরোনো কন্টেইনার বন্ধ করে নতুন করে বিল্ড ও আপ করা
                    docker compose down || true
                    docker compose up -d --build
                '''
            }
        }

        stage('Container Health Check') {
            steps {
                echo '🔍 Checking running containers and app status...'
                sh '''
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
