pipeline {
    agent any

    tools {
        maven "MAVEN3"
        jdk "OracleJDK11"
        ansible "Ansible"
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
                            sh 'sudo apt update && sudo apt install -y software-properties-common && sudo add-apt-repository --yes --update ppa:ansible/ansible && sudo apt install -y ansible'
                        }
                    }
                }
            }

            stage('Deploy with Ansible') {
                steps {
                    script {
                        def userInput = input(
                            id: 'userInput',
                            message: 'Enter the username:',
                            parameters: [string(name: 'TARGET_USER', defaultValue: '', description: 'Username to add')]
                        )

                        // Extract the value of TARGET_USER directly from userInput
                        def targetUser = userInput ? userInput.trim() : null

                        if (targetUser && !targetUser.isEmpty()) {
                            sh "cd /var/lib/jenkins/workspace/adding-users-pipeline/ansible && ansible-playbook -i inventory.yaml playbook.yaml --extra-vars \"target_user=${targetUser}\""
                        } else {
                            error("TARGET_USER is null or empty. Please provide a valid value.")
                        }
                    }
                }
            }

            stage('Checkstyle Analysis') {
                steps {
                    sh 'mvn checkstyle:checkstyle'
                }
            }

            stage('SonarQube Analysis') {
                environment {
                    scannerHome = tool 'sonar4.7'
                }
                steps {
                    withSonarQubeEnv('sonar') {
                        sh '''${scannerHome}/bin/sonar-scanner \
                                        -Dsonar.projectKey=addUsersProject \
                                        -Dsonar.projectName=addUsersProject \
                                        -Dsonar.projectVersion=1.0 \
                                        -Dsonar.sources=/var/lib/jenkins/workspace/adding-users-pipeline/addingUsers/ \
                                        -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                                        -Dsonar.junit.reportsPath=target/surefire-reports/ \
                                        -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                                        -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                    }

                    timeout(time: 10, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }
#
        post {
            success {
                echo 'Pipeline succeeded! Implement additional steps if needed.'
            }
            failure {
                echo 'Pipeline failed! Implement error handling or notifications.'
            }
        }
}
