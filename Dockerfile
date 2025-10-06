# Stage 1: Build the application
FROM openjdk:17-jdk-slim AS build

# Set working directory
WORKDIR /app

# Copy Gradle wrapper and build files
COPY . .

# Download dependencies
RUN ./gradlew dependencies --no-daemon

# Copy source code
COPY src ./src

# Build the fat JAR
RUN ./gradlew bootJar --no-daemon

# Stage 2: Create a lightweight runtime image
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the fat JAR from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the default Spring Boot port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
