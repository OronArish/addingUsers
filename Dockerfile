FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline

# Copy the Ansible playbook and inventory into the container
COPY ansible/playbook.yaml /ansible/playbook.yaml
COPY ansible/inventory.yaml /ansible/inventory.yaml
COPY ansible/clientkey.pem /var/lib/jenkins/workspace/adding-users-pipeline/clientkey.pem

# Copy the SSH key to the .ssh directory
COPY clientkey.pem /root/.ssh/id_rsa

# Run the Ansible playbook on container startup
CMD ["sh", "-c", "ansible-playbook -i /ansible/inventory.yaml /ansible/playbook.yaml --extra-vars 'target_user=${targetUser}'"]
