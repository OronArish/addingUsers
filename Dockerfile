FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/*

# Copy your Ansible playbook into the container
COPY ansible/playbook.yaml /ansible/playbook.yaml
COPY ansible/inventory.yaml /ansible/inventory.yaml
COPY ansible/clientkey.pem /root/.ssh/id_rsa

WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline

# Add known_hosts entries dynamically during build
ARG KNOWN_HOSTS_ENTRIES
RUN mkdir -p /root/.ssh && \
    echo "$KNOWN_HOSTS_ENTRIES" > /root/.ssh/known_hosts && \
    chmod 600 /root/.ssh/id_rsa && \
    chown -R root:root /root/.ssh

# Run the Ansible playbook on container startup
CMD ["ansible-playbook", "-i", "/ansible/inventory.yaml", "/ansible/playbook.yaml", "--extra-vars", "target_user=${targetUser}"]
