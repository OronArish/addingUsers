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
COPY ansible/clientkey.pem /var/lib/jenkins/workspace/adding-users-pipeline/ansible/clientkey.pem
COPY ansible/known_hosts /root/.ssh/known_hosts

# Set permissions for SSH key and known hosts
RUN chmod 600 /root/.ssh/id_rsa \
    && chmod 644 /root/.ssh/known_hosts

CMD ["sh", "-c", "ls -l /var/lib/jenkins/workspace/adding-users-pipeline/ansible && ansible-playbook -i /ansible/inventory.yaml /ansible/playbook.yaml --extra-vars 'target_user=${targetUser}'"]
# Run the Ansible playbook on container startup
CMD ["sh", "-c", "ansible-playbook -i /ansible/inventory.yaml /ansible/playbook.yaml --extra-vars 'target_user=${targetUser}'"]
