pipeline {
    agent any

    tools {
        maven "MAVEN3"
        jdk "OracleJDK11"
        ansible "Ansible" // Ensure this matches the configured tool name
    }

    stages {
        stage('Fetch code') {
            steps {
                git branch: 'main', url: 'https://github.com/OronArish/addingUsers.git'
            }
        }

        stage('Build with Maven') {
            steps {
                script {
                    sh 'mvn clean -DskipTest'
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                script {
                    sh '/var/lib/jenkins/tools/hudson.plugins.ansible.AnsibleInstallation/Ansible/bin/ansible-playbook -i /var/lib/jenkins/workspace/adding-users-pipeline/addingUsers/ansible/inventory.yaml /var/lib/jenkins/workspace/adding-users-pipeline/addingUsers/ansible/playbook.yaml'
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
