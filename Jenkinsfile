pipeline {
    agent any
    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/krishnadevopstraining-tech/simple-java-application.git'
            }   
        }
        stage('build') {
            steps {
                sh '''
                export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
                export PATH=$JAVA_HOME/bin:$PATH
                mvn clean package
                '''
            }
        }
        stage('test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('deploy') {
            steps {
                sh '''
                cp target/*.jar app.jar
                JENKINS_NODE_COOKIE=dontKillMe nohup java -jar app.jar --server.port=8083 > logs.logs 2>&1 &
                '''
            }
        }
    }
}
