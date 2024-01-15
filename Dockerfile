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

# Copy known_hosts to a temporary location
COPY /var/lib/jenkins/.ssh/known_hosts /tmp/known_hosts

# Move known_hosts to the desired location
RUN mkdir -p /root/.ssh && \
    mv /tmp/known_hosts /root/.ssh/known_hosts && \
    chmod 600 /root/.ssh/id_rsa && \
    chown -R root:root /root/.ssh

# Run the Ansible playbook on container startup
CMD ["ansible-playbook", "-i", "/ansible/inventory.yaml", "/ansible/playbook.yaml", "--extra-vars", "target_user=${targetUser}"]
