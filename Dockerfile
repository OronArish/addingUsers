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
COPY ansible/known_hosts /root/.ssh/known_hosts

WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline

# Run the Ansible playbook on container startup
RUN chmod 600 /root/.ssh/id_rsa
CMD ["sh", "-c", "ansible-playbook -i /ansible/inventory.yaml /ansible/playbook.yaml --extra-vars 'target_user=${targetUser}' -e 'ANSIBLE_HOST_KEY_CHECKING=False'"]

