# ── Stage 1: build the JAR ───────────────────────────────────────────────────
FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn package -DskipTests

# ── Stage 2: OpenShift-friendly runtime ──────────────────────────────────────
FROM registry.access.redhat.com/ubi8/openjdk-17

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
