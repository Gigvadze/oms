pipeline {
    agent none
    //tools{
      //  maven 'maven'
    //}
    stages {
        stage('Build') {
            agent {
               docker {
                    image 'maven:3.6-alpine' 
                    args '-v /root/.m2:/root/.m2' 
                }
            }
            steps {
                checkout scm
                sh 'mvn clean install'
                //sh 'mvn package'
                archiveArtifacts artifacts: 'target/*.war', fingerprint: true
            }
        }

        stage('checkout') {
            agent { label 'master' }
            steps {
                checkout scm
                sh 'docker pull hashicorp/terraform:light'
            }  
        } 
        stage('init') {
            agent { label 'master' }
            steps {
               // sh 'docker run -w /app -v /home/henadiy/.aws:/root/.aws -v `pwd`:/app hashicorp/terraform:light init'
               sh 'docker run -w /app -v `pwd`:/app hashicorp/terraform:light init'
            }
        } 
        stage('plan') {
            agent { label 'master' }
            steps {
                //sh 'docker run -w /app -v /root/.aws:/root/.aws -v `pwd`:/app hashicorp/terraform:light plan'
                sh 'docker run -w /app -v /home/henadiy/Terraform:/key -v `pwd`:/app hashicorp/terraform:light plan -var-file=/key/variables.tfvars'
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
            agent { label 'master' }
            steps {
                //sh 'docker run -w /app -v /root/.aws:/root/.aws -v `pwd`:/app hashicorp/terraform:light apply -auto-approve'   
                sh 'docker run -w /app -v /home/henadiy/Terraform:/key -v `pwd`:/app hashicorp/terraform:light apply -auto-approve -var-file=/key/variables.tfvars'
                sh 'docker run -w /app -v /home/henadiy/Terraform:/key -v `pwd`:/app hashicorp/terraform:light output > out.file'
            }
        }

        stage('Deploy') {
            agent { label 'master' }
            steps {
                // copy the application
                //sh 'scp target/*.jar jenkins@192.168.50.10:/opt/pet/'
                // start the application
                //sh "ssh jenkins@192.168.50.10 'nohup java -jar /opt/pet/spring-petclinic-1.5.1.jar &'"
                //sh 'sed -i "s/ //g" out.file && cut -d= -f2 out.file > out.file'
                echo "Deploying to Tomcat at http://10.26.34.81:8080/OMS"
                sh 'curl -s --upload-file target/OMS.war "http://henadiy:cubasbubas@10.26.34.81:8080/manager/text/deploy?path=/OMS&update=true&tag=${BUILD_TAG}"'
            }
        } 
    }
} 