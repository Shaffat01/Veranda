pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Pulling Veranda Project from GitHub...'
                checkout scm
            }
        }

        stage('Verify Web Files') {
            steps {
                echo '🧪 Checking required website files...'
                sh '''
                    if [ -f index.html ]; then
                        echo "✅ index.html found!"
                    else
                        echo "❌ index.html is missing!"
                        exit 1
                    fi
                '''
            }
        }

        stage('Deploy to Nginx') {
            steps {
                echo '🚀 Deploying website files to Nginx...'
                sh '''
                    # Clear old files
                    rm -rf /var/www/html/*

                    # Copy all website files
                    cp -r * /var/www/html/

                    echo "✅ Deploy Complete!"
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo '🌐 Testing website status on port 8081...'
                sh 'curl -sI http://localhost:8081 | head -n 1'
            }
        }
    }

    post {
        success {
            echo '🎉 Veranda Website is successfully LIVE on Port 8081!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
