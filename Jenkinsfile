pipeline {
    agent { docker 'maven:3.6-alpine' }
    
    stages {
    /*    stage ('Checkout') {
          steps {
            git 'http://10.26.34.64/henadiy/omspipe.git'
          }
        } */
        stage('Build') {
            steps {
                checkout scm
                sh 'mvn clean install'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
        stage('Test'){
            steps {
                sh 'mvn test' 
           //     junit '**/target/surefire-reports/TEST-*.xml'
            }
        } 
        stage('Package') {
            steps {
                sh 'mvn package'
            }
        } 
    }
}