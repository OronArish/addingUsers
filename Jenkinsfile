pipeline {
    agent any

    tools {
        maven "MAVEN3"
        jdk "OracleJDK11"
        ansible "Ansible"
    }

    environment {
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_REPO = 'oronops/adding-users-app'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Fetch code') {
            steps {
                git branch: 'main', url: 'https://github.com/OronArish/addingUsers.git'
            }
        }

//         stage('Build with Maven') {
//             steps {
//                 script {
//                     sh 'mvn clean -DskipTest'
//                 }
//             }
//         }

        stage('Check Ansible installation') {
            steps {
                script {
                    def ansibleInstalled = sh(script: 'command -v ansible', returnStatus: true)
                    if (ansibleInstalled != 0) {
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

                    def targetUser = userInput ? userInput.trim() : null

                    if (targetUser && !targetUser.isEmpty()) {
                        sh "cd /var/lib/jenkins/workspace/adding-users-pipeline/ansible && ansible-playbook -i inventory.yaml playbook.yaml --extra-vars \"target_user=${targetUser}\""
                    } else {
                        error("TARGET_USER is null or empty. Please provide a valid value.")
                    }
                }
            }
        }

        stage('Install Docker') {
            steps {
                script {
                    def dockerInstalled = sh(script: 'command -v docker', returnStatus: true)

                    if (dockerInstalled != 0) {
                        sh '''
                            sudo apt-get update &&
                            sudo apt-get install -y \
                                ca-certificates \
                                curl \
                                gnupg \
                                software-properties-common

                            sudo install -m 0755 -d /etc/apt/keyrings &&
                            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
                            sudo chmod a+r /etc/apt/keyrings/docker.gpg &&

                            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                                $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

                            sudo apt-get update &&
                            sudo apt-get install -y \
                                docker-ce \
                                docker-ce-cli \
                                containerd.io \
                                docker-buildx-plugin \
                                docker-compose-plugin
                        '''

                        if (!isUserInDockerGroup()) {
                            sh 'sudo usermod -aG docker jenkins'
                            echo 'Jenkins user added to the docker group. Restarting Jenkins agent...'
                            sh 'sudo systemctl restart jenkins.service'
                        } else {
                            echo 'Jenkins user is already in the docker group. No restart required.'
                        }
                    }
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_registry', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        sh 'docker build -t $DOCKER_REGISTRY/$DOCKER_REPO:$DOCKER_TAG .'
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD $DOCKER_REGISTRY'
                        sh 'docker push $DOCKER_REGISTRY/$DOCKER_REPO:$DOCKER_TAG'
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

    post {
        success {
            echo 'Pipeline succeeded! Implement additional steps if needed.'
        }
        failure {
            echo 'Pipeline failed! Implement error handling or notifications.'
        }
    }
}

def isUserInDockerGroup() {
    return sh(script: 'groups jenkins | grep -q docker', returnStatus: true) == 0
}
