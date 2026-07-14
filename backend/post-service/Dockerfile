FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app

COPY pom.xml .
COPY common/pom.xml common/
COPY post-service/pom.xml post-service/

RUN mvn dependency:go-offline -pl post-service -am -B -q

COPY common/src common/src
COPY post-service/src post-service/src

RUN mvn package -pl post-service -am -DskipTests -B -q

FROM eclipse-temurin:17-jre
WORKDIR /app

RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring

COPY --from=builder /app/post-service/target/*.jar app.jar

EXPOSE 8083

ENTRYPOINT ["java", "-jar", "app.jar"]
