FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline

# Create SSH directory and copy key and known_hosts
RUN mkdir -p /root/.ssh
COPY known_hosts /root/.ssh/known_hosts
COPY ansible/clientkey.pem /root/.ssh/id_rsa

# Set correct permissions
RUN chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/id_rsa

# Copy your Ansible playbook into the container
COPY ansible/playbook.yaml /ansible/playbook.yaml
COPY ansible/inventory.yaml /ansible/inventory.yaml

# Run the Ansible playbook on container startup
CMD ["sh", "-c", "ansible-playbook -i /ansible/inventory.yaml /ansible/playbook.yaml --extra-vars 'target_user=${targetUser}'"]
