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
                echo '🚀 Deploying website files, CSS, JS & Images to Nginx...'
                sh '''
                    # Old files delete kora
                    rm -rf /var/www/html/*

                    # All files and folders (css, js, images, html) copy kora
                    cp -r * /var/www/html/

                    echo "✅ Deploy Complete!"
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo '🌐 Testing website status...'
                sh 'curl -sI http://localhost | head -n 1'
            }
        }
    }

    post {
        success {
            echo '🎉 Veranda Website is successfully LIVE!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
