FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline

# Copy the Ansible playbook and inventory into the container
COPY ansible /var/lib/jenkins/workspace/adding-users-pipeline/ansible


# Copy SSH key and known_hosts file
COPY ansible/clientkey.pem /root/.ssh/id_rsa
COPY ansible/known_hosts /root/.ssh/known_hosts

# Set permissions for SSH key and known hosts
RUN chmod 600 /root/.ssh/id_rsa \
    && chmod 644 /root/.ssh/known_hosts

# Run the Ansible playbook on container startup
CMD ["sh", "-c", "ls -l ansible && ansible-playbook -i ansible/inventory.yaml ansible/playbook.yaml --extra-vars 'target_user=$TARGET_USER'"]
