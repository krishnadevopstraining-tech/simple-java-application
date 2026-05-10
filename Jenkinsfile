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
        stage('Sonar Analysis') {
            steps {

                script {

                    def scannerHome = tool 'sonarqube'

                    withSonarQubeEnv('sonarqube') {

                        sh """
                        ${scannerHome}/bin/sonar-scanner \
                        -Dsonar.projectKey=simple-java-application1 \
                        -Dsonar.sources=. \
                        -Dsonar.java.binaries=target/classes
                        """
                    }
                }
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
                JENKINS_NODE_COOKIE=dontKillMe nohup java -jar app.jar --server.port=8081 > logs.logs 2>&1 &
                '''
            }
        }
    }
}
