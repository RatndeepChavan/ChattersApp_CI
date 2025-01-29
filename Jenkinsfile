pipeline {
    agent any

    stages {
        stage('All installation checks') {
            steps {
                sh '/dependency-check/bin/dependency-check.sh -v'
                sh '/snyk-linux -v'
                sh 'trivy -v'
                sh 'docker -v'
                sh 'docker-compose -v'
            }
        }
        stage('Git') {
            steps {
                git branch: 'dev/ratndeep', changelog: false, poll: false, url: 'https://github.com/RatndeepChavan/ChattersApp.git'
            }
        }
        stage('OWASP dependanct-check') {
            steps {
                sh '/dependency-check/bin/dependency-check.sh --advancedHelp --prettyPrint --disableNodeJS -s package-lock.json -s packages/client/package-lock.json -s packages/server/package-lock.json'
            }
        }
        stage('Snyk') {
            environment {
                SNYK_SECRET = credentials('snyk-secret')

            }
            steps {
                sh '/snyk-linux auth $SNYK_SECRET'
                sh '/snyk-linux test --all-projects'
            }
        }
        stage('Trivy') {
            steps {
                sh 'trivy fs . --skip-dirs packages/server/logs --skip-dirs packages/server/docs --skip-dirs packages/client/docs'
            }
        }
        stage('Image build') {
            steps {
                sh 'sudo docker-compose -f packages/deployment-ci.yml build'
            }
        }
        stage('Image scan') {
            steps {
                sh 'trivy image ratndeep/chattersapp_frontend:v1.0'
                sh 'trivy image ratndeep/chattersapp_backend:v1.0'
            }
        }
        stage('Push images') {
            steps {
                sh 'cat /docker_password.txt | docker login --username ratndeep --password-stdin'
                sh 'docker push ratndeep/chattersapp_frontend:v1.0'
                sh 'docker push ratndeep/chattersapp_backend:v1.0'
            }
        }
    }
}
