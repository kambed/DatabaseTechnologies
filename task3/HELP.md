# START MYSQL DATABASE W KONTENERZE DOCKERA ZA POMOCĄ KOMEND DOCKERA

```
docker pull mysql:5.7

docker run --name database -p 3306:3306 -e MYSQL_USER=user -e MYSQL_PASSWORD=password -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_DATABASE=db -v C:\Users\ebedkam\Downloads\docker\docker\src\main\resources\init.sql:/docker-entrypoint-initdb.d/init.sql -d mysql:5.7
```

# START MYSQL DATABASE W KONTENERZE DOCKERA ZA DOCKER-COMPOSE

```
version: '3.3'
services:
  db:
    container_name: database
    image: mysql:5.7
    restart: unless-stopped
    env_file: .env
    ports:
      - '${MYSQL_LOCAL_PORT}:${MYSQL_DOCKER_PORT}'
    healthcheck:
      test: [ "CMD", "mysqladmin", "ping", "-h", "localhost" ]
      timeout: 20s
      retries: 10
    volumes:
      - ./src/main/resources/init.sql:/docker-entrypoint-initdb.d/init.sql
```

# START MYSQL DATABASE W KONTENERZE DOCKERA ZA DOCKER-COMPOSE Z STAŁYMI DANYMI (PREZENTACJA VOLUME)

```
version: '3.3'
services:
  db:
    container_name: database
    image: mysql:5.7
    restart: unless-stopped
    env_file: .env
    ports:
      - '${MYSQL_LOCAL_PORT}:${MYSQL_DOCKER_PORT}'
    healthcheck:
      test: [ "CMD", "mysqladmin", "ping", "-h", "localhost" ]
      timeout: 20s
      retries: 10
    volumes:
      - ./src/main/resources/init.sql:/docker-entrypoint-initdb.d/init.sql
      - data:/var/lib/mysql
volumes:
  data:
```

Dane znajdują się:
\\wsl$\docker-desktop-data\data\docker\volumes

Aby dane zostały usunięte:
docker compose down -v
lub należy usunąć volume docker_data

# START SPRING (.jar już zbudowany przez mvn i pobrany z /target) I MYSQL DATABASE W KONTENERZE DOCKERA ZA DOCKER-COMPOSE

Dockerfile:
```
FROM eclipse-temurin:21
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

--------------------------------

docker build -t kambed/spring:v1 -f Dockerfile .

--------------------------------

Docker-compose:
```
version: '3.3'
services:
  db:
    container_name: database
    image: mysql:5.7
    restart: unless-stopped
    env_file: .env
    ports:
      - '${MYSQL_LOCAL_PORT}:${MYSQL_DOCKER_PORT}'
    expose:
      - '${MYSQL_LOCAL_PORT}'
    healthcheck:
      test: [ "CMD", "mysqladmin", "ping", "-h", "localhost" ]
      timeout: 20s
      retries: 10
    volumes:
      - ./src/main/resources/init.sql:/docker-entrypoint-initdb.d/init.sql
      - data:/var/lib/mysql
  app:
    container_name: spring
    build: .
    restart: unless-stopped
    env_file: .env
    ports:
      - '${SPRING_LOCAL_PORT}:${SPRING_DOCKER_PORT}'
    depends_on:
      db:
        condition: service_healthy
volumes:
  data:
```
### !!! PRZEŁĄCZYĆ URL W .env !!!

# START SPRING (.jar budowany automatycznie) I MYSQL DATABASE W KONTENERZE DOCKERA ZA DOCKER-COMPOSE

Dockerfile:
```
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
```