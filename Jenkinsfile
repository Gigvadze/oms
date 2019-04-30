pipeline {
    agent { label 'JenkinsAgent' }
    tools {
        maven 'maven'
    }
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