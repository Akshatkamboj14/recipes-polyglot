# Stage 1: Build
FROM eclipse-temurin:17-jdk-focal AS build
WORKDIR /app
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline
COPY src src
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-focal
WORKDIR /app
COPY --from=build /app/target/apigate-0.0.1-SNAPSHOT.jar app.jar
USER nobody
ENTRYPOINT ["java", "-jar", "app.jar"]
EXPOSE 8080

