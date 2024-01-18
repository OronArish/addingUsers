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

# Copy SSH key and known_hosts file
COPY ansible/clientkey.pem /ansible/clientkey.pem
COPY ansible/known_hosts /ansible/known_hosts

# Change ownership and permissions
RUN chown -R root:root /ansible && \
    chmod 600 /ansible/clientkey.pem && \
    chmod 644 /ansible/known_hosts

# Copy the SSH key to the .ssh directory
COPY ansible/clientkey.pem /root/.ssh/id_rsa

# Change ownership and permissions
RUN chmod 600 /root/.ssh/id_rsa

# Run the Ansible playbook on container startup
CMD ["sh", "-c", "ansible-playbook -i /ansible/inventory.yaml /ansible/playbook.yaml --extra-vars 'target_user=${targetUser}'"]
