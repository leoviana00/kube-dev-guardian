# Applications - kube-dev-guardian

Aplicações utilizadas como workloads de referência no projeto `kube-dev-guardian`.

## Objetivo

Fornecer workloads reais para validar:

- execução em Kubernetes;
- comunicação entre serviços;
- mensageria assíncrona;
- containerização;
- Helm;
- GitOps;
- observabilidade;
- gerenciamento do ciclo de vida dos workloads.

## Estrutura

```text
apps/
├── customer-api/
├── order-producer/
└── order-consumer/
```

## Customer API

API REST responsável por disponibilizar dados de clientes.

```
Tecnologias
Java 21
Spring Boot
Maven
Spring Web
Spring Actuator
Micrometer
OpenAPI
```

- Endpoints

```
GET /api/customers
GET /api/customers/{id}
```

- Endpoints de monitoramento:

```
GET /actuator/health
GET /actuator/prometheus
```

Os dados utilizados atualmente são mantidos em memória, pois o objetivo da aplicação é servir como workload de laboratório.

## Order Producer

Serviço responsável por criar e publicar eventos de pedidos.

```
Tecnologias
Java 21
Spring Boot
Maven
Spring Web
Spring Kafka
Spring Actuator
```

- Endpoint

```
POST /api/orders
```

O serviço publica eventos no tópico Kafka:
```
orders
Evento
OrderCreated
```

Principais informações:

```
orderId
customerId
total
createdAt
```

## Order Consumer

Serviço responsável por consumir os eventos publicados pelo order-producer.

```
Tecnologias
Java 21
Spring Boot
Maven
Spring Kafka
Spring Actuator
Kafka
```

Tópico:

```
orders
```

Consumer Group:

```
order-consumer
```

O serviço recebe e processa eventos OrderCreated.

## Comunicação

O fluxo entre Producer e Consumer é baseado em mensageria assíncrona:

```
Client
  |
  | HTTP
  v
order-producer
  |
  | Kafka
  v
orders
  |
  | consume
  v
order-consumer
```

## Containerização

As aplicações possuem Dockerfiles para geração das imagens utilizadas no ambiente Kubernetes.

As imagens utilizam build multi-stage e runtime Java 21.

As aplicações são executadas com usuário não-root.

## Kubernetes

Os workloads são executados no namespace:

```
team-a
```

Os deployments são empacotados através dos Helm Charts localizados em:

```
infrastructure/helm/
```

Atualmente:

```
infrastructure/helm/
├── order-producer/
└── order-consumer/
```

O customer-api permanece como workload de aplicação de referência para o laboratório.

## Configuração

Configurações específicas de ambiente devem ser realizadas através de variáveis de ambiente ou dos mecanismos de configuração definidos pelos respectivos Helm Charts.

Exemplo utilizado pelo Producer e Consumer:

```
KAFKA_BOOTSTRAP_SERVERS
```

## Testes

As aplicações possuem testes automatizados executados através do Maven:

```bash
mvn clean test
```

A comunicação Kafka entre Producer e Consumer também foi validada ponta a ponta.

## Papel no Projeto

As aplicações não representam necessariamente sistemas de negócio completos.

Elas funcionam como workloads controlados para validar a arquitetura do kube-dev-guardian.

Ao longo do projeto, esses workloads serão utilizados para testar:

```
Aplicações
    |
    +-- Kubernetes
    +-- Kafka
    +-- Helm
    +-- GitOps
    +-- Observability
    +-- Autoscaling
    +-- Idle Detection
    +-- Lifecycle Management
    +-- Self-Service
```