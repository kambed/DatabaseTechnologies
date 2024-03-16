FROM eclipse-temurin:21-jdk as builder
WORKDIR /opt/app
COPY ./src ./src
COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline
RUN ./mvnw clean install

FROM eclipse-temurin:21-jre
COPY --from=builder /opt/app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]