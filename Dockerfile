FROM maven:3.6.3-jdk-11

WORKDIR /var/lib/jenkins/workspace/adding-users-pipeline/

COPY pom.xml .
COPY src/ src/

RUN mvn clean install -DskipTests

CMD ["java", "-jar", "target/my-maven-project-1.0-SNAPSHOT.jar"]
