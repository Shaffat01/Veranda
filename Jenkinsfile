pipeline {
    agent any

    // 1. Environment Variable Definition
    environment {
        IMAGE_NAME = "veranda-app"
    }

    // 2. Parameters Definition (Inputs from User)
    parameters {
        choice(
            name: 'DEPLOY_ENV', 
            choices: ['dev', 'prod'], 
            description: 'Select Environment to Deploy'
        )
        string(
            name: 'IMAGE_TAG', 
            defaultValue: 'v1.0', 
            description: 'Docker Image Tag/Version'
        )
        booleanParam(
            name: 'RUN_HEALTH_CHECK', 
            defaultValue: true, 
            description: 'Run HTTP Health Check after deploy?'
        )
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Pulling code from GitHub...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker Image: ${IMAGE_NAME}:${params.IMAGE_TAG}"
                sh "docker build -t ${IMAGE_NAME}:${params.IMAGE_TAG} ."
            }
        }

        stage('Conditional Deployment (if-else)') {
            steps {
                script {
                    if (params.DEPLOY_ENV == 'dev') {
                        echo "🚀 Deploying to DEV Environment on Port 8083..."
                        sh '''
                            docker stop veranda-dev-container || true
                            docker rm veranda-dev-container || true
                            docker run -d --name veranda-dev-container -p 8083:80 ${IMAGE_NAME}:${params.IMAGE_TAG}
                        '''
                    } else if (params.DEPLOY_ENV == 'prod') {
                        echo "🚀 Deploying to PROD Environment on Port 8082..."
                        sh '''
                            docker stop veranda-prod-container || true
                            docker rm veranda-prod-container || true
                            docker run -d --name veranda-prod-container -p 8082:80 ${IMAGE_NAME}:${params.IMAGE_TAG}
                        '''
                    } else {
                        error("❌ Invalid environment selected!")
                    }
                }
            }
        }

        stage('Health Check') {
            // 3. When Condition (Runs only if RUN_HEALTH_CHECK is true)
            when {
                expression { return params.RUN_HEALTH_CHECK }
            }
            steps {
                echo '🔍 Running Health Check on deployed container...'
                script {
                    def targetPort = (params.DEPLOY_ENV == 'dev') ? '8083' : '8082'
                    sh "curl -sI http://localhost:${targetPort} | head -n 1"
                }
            }
        }
    }

    // 4. Post Actions
    post {
        always {
            echo '🧹 Pipeline execution completed.'
        }
        success {
            echo "🎉 SUCCESS: Deployed Version ${params.IMAGE_TAG} to ${params.DEPLOY_ENV} Environment!"
        }
        failure {
            echo "❌ FAILURE: Pipeline failed for ${params.DEPLOY_ENV} Environment!"
        }
    }
}
