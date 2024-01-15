FROM ubuntu:latest

# Copy your Ansible playbook into the container
COPY ansible/playbook.yml /playbook.yml

WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline

# Run the Ansible playbook on container startup
CMD ["ansible-playbook", "/playbook.yml"]
