# Step 1: Build the application with Maven
FROM maven:3.9.5-eclipse-temurin-21 AS build
WORKDIR /app

# Copy the project files and build with Maven
COPY pom.xml .
COPY src ./src

# Build the Spring Boot application (skip tests for faster builds)
RUN mvn clean package -DskipTests

# Step 2: Use a lightweight JDK 21 runtime for the final image
FROM eclipse-temurin:21-jdk

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the previous stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port the Spring Boot app runs on
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]


