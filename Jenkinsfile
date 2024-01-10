pipeline {
    agent any

    tools {
        maven "MAVEN3"
        jdk "OracleJDK11"
        // You can add Ansible tool here if needed
    }

    environment {
        ANSIBLE_HOME = "${WORKSPACE}/addingUsers/ansible" // Adjust if Ansible files are in a folder named 'ansible' within 'addingUsers'
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
                    // Your Maven build commands here
                    sh 'mvn clean -DskipTest'
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                script {
                    // Assuming your Ansible files are in the 'ansible' directory within 'addingUsers'
                    sh "${ANSIBLE_HOME}/ansible-playbook -i ${ANSIBLE_HOME}/ansible/inventory.yaml ${ANSIBLE_HOME}/ansible/playbook.yaml"
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
