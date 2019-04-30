pipeline {
    agent { label 'JenkinsAgent'}
    tools{
        maven 'maven'
    }
    stages {
        stage('Build') {
            agent { docker 'maven:3.6-alpine' }
            steps {
                checkout scm
                sh 'mvn clean install'
                //sh 'mvn package'
                archiveArtifacts artifacts: 'target/*.war', fingerprint: true
            }
        } 
        stage('Test'){
            steps {
                sh 'mvn test' 
                
            }
        } 
        
        stage('Deploy') {
            steps {
                // copy the application
                //sh 'scp target/*.jar jenkins@192.168.50.10:/opt/pet/'
                // start the application
                //sh "ssh jenkins@192.168.50.10 'nohup java -jar /opt/pet/spring-petclinic-1.5.1.jar &'"
                echo "Deploying to Tomcat at http://10.26.34.81:8080/OMS"
                sh 'curl -s --upload-file target/OMS.war "http://henadiy:cubasbubas@10.26.34.81:8080/manager/text/deploy?path=/OMS&update=true&tag=${BUILD_TAG}"'
            }
        } 
    }
}