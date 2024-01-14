FROM maven:3.6.3-jdk-11

WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline/addingUsers

COPY . .

RUN mvn clean install -DskipTest

CMD ["java", "-jar", "target/addingUsers-1.0-SNAPSHOT.jar"]