# ============================================================
# ORDER PRODUCER
# MULTI-STAGE DOCKER BUILD
# ============================================================


# ============================================================
# BUILD STAGE
#
# Compila a aplicação Spring Boot e gera o JAR executável.
# ============================================================

FROM maven:3.9.16-eclipse-temurin-21 AS build

WORKDIR /app


# ============================================================
# MAVEN DEPENDENCIES
#
# Copia inicialmente apenas o pom.xml para aproveitar o cache
# de camadas do Docker.
# ============================================================

COPY pom.xml .


# ============================================================
# DOWNLOAD MAVEN DEPENDENCIES
# ============================================================

RUN mvn dependency:go-offline -B


# ============================================================
# APPLICATION SOURCE CODE
# ============================================================

COPY src ./src


# ============================================================
# BUILD APPLICATION
#
# Os testes são executados no pipeline Maven/CI.
# Durante a construção da imagem, apenas o artefato é gerado.
# ============================================================

RUN mvn clean package -DskipTests


# ============================================================
# RUNTIME STAGE
#
# Imagem reduzida contendo apenas o JRE necessário para
# executar a aplicação.
# ============================================================

FROM eclipse-temurin:21-jre

WORKDIR /app


# ============================================================
# NON-ROOT USER
#
# O container não deve executar a aplicação como root.
# ============================================================

RUN useradd \
    --system \
    --create-home \
    --uid 10001 \
    appuser


# ============================================================
# APPLICATION ARTIFACT
#
# Copia o JAR gerado no estágio de build.
#
# O wildcard evita acoplamento à versão específica definida
# no pom.xml.
# ============================================================

COPY --from=build /app/target/*.jar app.jar


# ============================================================
# CONTAINER USER
# ============================================================

USER 10001


# ============================================================
# APPLICATION ENTRYPOINT
# ============================================================

ENTRYPOINT ["java", "-jar", "app.jar"]