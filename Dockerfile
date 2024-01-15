FROM maven:3.6.3-jdk-11

WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline/

COPY . .

RUN mvn clean install -DskipTests

CMD ["tail", "-f", "/dev/null"]
