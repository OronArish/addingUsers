FROM ubuntu:latest

# Copy your Ansible playbook into the container
COPY ansible/playbook.yaml /playbook.yaml

WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline

# Run the Ansible playbook on container startup
CMD ["ansible-playbook", "/ansible/playbook.yaml"]
