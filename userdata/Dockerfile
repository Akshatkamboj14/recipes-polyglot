# Multi-stage build to create a small final image
# Stage 1: Build the application
FROM eclipse-temurin:17-jdk-focal as build
WORKDIR /app
# Copy the Maven wrapper and pom.xml to download dependencies
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
# Download all dependencies, including the PostgreSQL driver
RUN ./mvnw dependency:go-offline

# Copy the rest of the source code
COPY src src

# Build the project, packaging it into a JAR file
RUN ./mvnw clean package -DskipTests

# Stage 2: Create the final lean image
FROM eclipse-temurin:17-jre-focal
WORKDIR /app
# Copy the built JAR from the 'build' stage
COPY --from=build /app/target/*.jar app.jar
# The command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

