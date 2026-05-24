pipeline {
    agent any
    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/krishnadevopstraining-tech/simple-java-application.git'
            }   
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t krishnadevopstraining/simple-java-application:latest .'
            }
        }
        stage('docker push') {
            steps {
                sh 'docker push krishnadevopstraining/simple-java-application:latest'
            }
        }
        stage('deploy') {
            steps {
                sh 'docker run -d -p 9090:8080 --name simple-java-application krishnadevopstraining/simple-java-application:latest'
            }
        }
    }
}
