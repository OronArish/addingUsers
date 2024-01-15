FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/*

# Copy your Ansible playbook into the container
COPY ansible/playbook.yaml /ansible/playbook.yaml
COPY ansible/inventory.yaml /ansible/inventory.yaml

WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline

# Run the Ansible playbook on container startup
CMD ["sh", "-c", "ansible-playbook -i /ansible/inventory.yaml /ansible/playbook.yaml --extra-vars 'target_user=${targetUser}'"]

