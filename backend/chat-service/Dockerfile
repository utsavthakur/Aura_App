FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app

COPY pom.xml .
COPY common/pom.xml common/
COPY chat-service/pom.xml chat-service/

RUN mvn dependency:go-offline -pl chat-service -am -B -q

COPY common/src common/src
COPY chat-service/src chat-service/src

RUN mvn package -pl chat-service -am -DskipTests -B -q

FROM eclipse-temurin:17-jre
WORKDIR /app

RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring

COPY --from=builder /app/chat-service/target/*.jar app.jar

EXPOSE 8085

ENTRYPOINT ["java", "-jar", "app.jar"]
