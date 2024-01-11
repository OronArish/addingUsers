pipeline {
    agent any

    tools {
        maven "MAVEN3"
        jdk "OracleJDK11"
        ansible "Ansible" // Make sure this matches the tool name configured in Jenkins
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

        stage('Check Ansible installation') {
                    steps {
                        script {
                            // Check if Ansible is installed
                            def ansibleInstalled = sh(script: 'command -v ansible', returnStatus: true)
                            if (ansibleInstalled != 0) {
                                // Install Ansible if not installed
                                sh 'sudo apt update && sudo apt install software-properties-common && sudo add-apt-repository --yes --update ppa:ansible/ansible && sudo apt install ansible'
                            }
                        }
                    }
                }

        stage('Deploy with Ansible') {
            steps {
                script {
                    sh 'ansible-playbook -i addingUsers/ansible/inventory.yaml addingUsers/ansible/playbook.yaml'
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
