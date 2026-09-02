# customer-api

API REST de clientes do projeto Kube Dev Guardian.

## Stack

- Java 21
- Spring Boot 3.5.7
- Maven
- Spring Boot Actuator
- Micrometer Prometheus

## Execucao

`powershell
mvn spring-boot:run
`

## Endpoints de infraestrutura

- GET /actuator/health
- GET /actuator/info
- GET /actuator/prometheus