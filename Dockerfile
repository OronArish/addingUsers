FROM maven:3.6.3-jdk-11

WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline/

COPY . .

RUN mvn clean install -DskipTests

CMD ["java", "-cp", "target/my-maven-project-1.0-SNAPSHOT.jar", "com.example.Main"]
