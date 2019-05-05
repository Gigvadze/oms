pipeline {
    agent {label 'JenkinsAgent'}
    //tools{
      //  maven 'maven'
    //}
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

        stage('checkout') {
            steps {
                checkout scm
                sh 'docker pull hashicorp/terraform:light'
            }  
        }
        stage('init') {
            steps {
               // sh 'docker run -w /app -v /home/henadiy/.aws:/root/.aws -v `pwd`:/app hashicorp/terraform:light init'
               sh 'docker run -w /app -v `pwd`:/app hashicorp/terraform:light init'
            }
        }
        stage('plan') {
            steps {
                //sh 'docker run -w /app -v /root/.aws:/root/.aws -v `pwd`:/app hashicorp/terraform:light plan'
                sh 'docker run -w /app -v /home/henadiy/Terraform:/app -v `pwd`:/app hashicorp/terraform:light plan -var-file=variables.tfvars'
            }
        }
        stage('approval') {
            options {
                timeout(time: 1, unit: 'HOURS') 
            }
            steps {
                input 'approve the plan to proceed and apply'
            }
        }
        stage('apply') {
            steps {
                //sh 'docker run -w /app -v /root/.aws:/root/.aws -v `pwd`:/app hashicorp/terraform:light apply -auto-approve'   
                sh 'docker run -w /app -v /home/henadiy/Terraform:/app -v `pwd`:/app hashicorp/terraform:light apply -auto-approve -var-file=variables.tfvars'
                cleanWs()
            }
        }

        stage('Deploy') {
            agent { label JenkinsAgent }
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