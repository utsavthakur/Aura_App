FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app

COPY pom.xml .
COPY common/pom.xml common/
COPY notification-service/pom.xml notification-service/

RUN mvn dependency:go-offline -pl notification-service -am -B -q

COPY common/src common/src
COPY notification-service/src notification-service/src

RUN mvn package -pl notification-service -am -DskipTests -B -q

FROM eclipse-temurin:17-jre
WORKDIR /app

RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring

COPY --from=builder /app/notification-service/target/*.jar app.jar

EXPOSE 8086

ENTRYPOINT ["java", "-jar", "app.jar"]
