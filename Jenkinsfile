pipeline {
    agent none
    
    stages {
        stage('Build') {
            agent {
               docker {
                          image 'maven:3.6-alpine' 
                      }
            }
            steps {
                checkout scm
                sh 'mvn clean install'
                sh 'mvn clean package'
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
                   sh 'docker run -w /app -v `pwd`:/app hashicorp/terraform:light init'
            }
        } 
        stage('plan') {
            agent { label 'master' }
            steps {
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
        stage('apply and deploy') {
            agent { label 'master' }
            steps {
                sh 'docker run -w /app -v /home/henadiy/Terraform:/key -v `pwd`:/app hashicorp/terraform:light apply -auto-approve -var-file=/key/variables.tfvars'
                sh 'docker run -w /app -v /home/henadiy/Terraform:/key -v `pwd`:/app hashicorp/terraform:light output aws_instance_public_ip > out.file'
                sh 'ip=$(<out.file)'
            }
        }

    }
} 