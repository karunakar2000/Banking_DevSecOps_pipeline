# app/Dockerfile
# Container image for BankingOnline application.

# 1) Lightweight JDK runtime image
FROM eclipse-temurin:17-jre-alpine

# Workdir inside container
WORKDIR /app

# Copy the Spring Boot fat-jar built by Maven in the pipeline
# (e.g. target/banking-online.jar or banking-online-1.0.0.jar)
COPY target/banking-online*.jar app.jar
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --retries=5 \
  CMD wget -qO- http://localhost:8080/actuator/health | grep '"status":"UP"' || exit 1

ENV JAVA_OPTS="-Xms256m -Xmx512m"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
