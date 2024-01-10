pipeline {
    agent any

    tools {
        maven "MAVEN3"
        jdk "OracleJDK11"
        // You can add Ansible tool here if needed
    }

     environment {
             ANSIBLE_HOME = "${WORKSPACE}/addingUsers"
         }

         stages {
             stage('Fetch code') {
                 steps {
                     git branch: 'main', url: 'https://github.com/OronArish/addingUsers.git'
                 }
             }

             stage('Build with Maven') {
                 steps {
                     dir('addingUsers') {
                         script {
                             sh 'mvn clean install'
                         }
                     }
                 }
             }

             stage('Deploy with Ansible') {
                 steps {
                     script {
                         // Assuming your Ansible files are in the 'addingUsers' directory
                         sh "${ANSIBLE_HOME}/ansible-playbook -i ${ANSIBLE_HOME}/inventory.yaml ${ANSIBLE_HOME}/playbook.yaml"
                     }
                 }
             }
         }

         post {
             success {
                 echo 'Pipeline succeeded! Implement additional steps if needed.'
             }
             failure {
                 echo 'Pipeline failed! Implement error handling or notifications.'
             }
         }
     }
