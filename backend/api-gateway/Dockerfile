FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app

COPY pom.xml .
COPY common/pom.xml common/
COPY api-gateway/pom.xml api-gateway/

RUN mvn dependency:go-offline -pl api-gateway -am -B -q

COPY common/src common/src
COPY api-gateway/src api-gateway/src

RUN mvn package -pl api-gateway -am -DskipTests -B -q

FROM eclipse-temurin:17-jre
WORKDIR /app

RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring

COPY --from=builder /app/api-gateway/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
