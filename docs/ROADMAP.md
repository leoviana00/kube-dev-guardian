# Kube Dev Guardian — PoC Roadmap

## 1. Visão

O **Kube Dev Guardian** é uma Proof of Concept para estudar uma abordagem de governança e gerenciamento automatizado do ciclo de vida de workloads Kubernetes em ambientes não produtivos.

A proposta é reduzir a intervenção manual do time de DevOps, permitindo que workloads ociosos sejam identificados, notificados e, conforme políticas previamente definidas, suspensos automaticamente.

Os times devem continuar tendo autonomia para reativar seus próprios serviços através de uma camada de self-service, sem necessidade de acesso direto ao cluster ou execução manual de comandos `kubectl`.

A PoC também será utilizada para estudar:

* Kubernetes
* Java / Spring Boot
* Docker
* Helm
* GitOps / Argo CD
* Prometheus / Grafana
* Apache Kafka
* KEDA
* Kubernetes RBAC
* ResourceQuota / LimitRange
* NetworkPolicy
* Segurança de APIs
* Auditoria
* Automação de lifecycle
* Kubernetes Operator / CRD
* IA aplicada a operações de plataforma

---

# 2. Objetivo da PoC

Validar o seguinte cenário:

```text
Workload
    │
    ▼
Atividade monitorada
    │
    ▼
Período de ociosidade identificado
    │
    ▼
Política de lifecycle
    │
    ├── Ativo
    │
    ├── Alerta
    │
    ├── Warning
    │
    └── Suspensão
             │
             ▼
        Replicas = 0
             │
             ▼
      Developer Self-Service
             │
             ▼
        Serviço reativado
```

A PoC deve demonstrar que esse processo pode ser realizado de forma automatizada, segura, auditável e com segregação entre os diferentes times.

---

# 3. Arquitetura evolutiva

A solução será construída incrementalmente.

```text
┌─────────────────────────────────────────────────────────────┐
│                    KUBE DEV GUARDIAN                       │
└─────────────────────────────────────────────────────────────┘

 FASE 1       FASE 2        FASE 3        FASE 4
    │             │             │             │
    ▼             ▼             ▼             ▼

┌───────┐    ┌──────────┐   ┌──────────┐  ┌──────────────┐
│  LAB  │───▶│ SERVICES │──▶│  GITOPS  │─▶│OBSERVABILITY │
└───────┘    └──────────┘   └──────────┘  └──────┬───────┘
                                                  │
                                                  ▼
 FASE 5       FASE 6        FASE 7        FASE 8
    │             │             │             │
    ▼             ▼             ▼             ▼

┌───────┐    ┌──────────┐   ┌──────────┐  ┌──────────────┐
│ KEDA  │───▶│ GUARDIAN │──▶│GOVERNANCE│─▶│SELF-SERVICE  │
└───────┘    └──────────┘   └──────────┘  └──────────────┘
                                  │
                                  ▼
                         ┌─────────────────┐
                         │ FUTURO          │
                         │ Operator / AI   │
                         └─────────────────┘
```

---

# 4. Fases do projeto

## Fase 1 — Laboratório Kubernetes

### Objetivo

Preparar o ambiente local de desenvolvimento e criar o cluster Kubernetes que será utilizado durante toda a PoC.

### Tecnologias

* Windows
* Docker Desktop
* Kubernetes
* kubectl
* Helm
* Git

### Atividades

* [ ] Preparar Docker Desktop
* [ ] Habilitar Kubernetes
* [ ] Instalar/configurar kubectl
* [ ] Instalar Helm
* [ ] Validar comunicação com o cluster
* [ ] Criar namespaces iniciais
* [ ] Criar estrutura inicial do repositório
* [ ] Criar documentação básica do laboratório

### Critério de conclusão

Executar com sucesso:

```bash
kubectl get nodes
kubectl get namespaces
helm version
```

E possuir um cluster Kubernetes funcional para as próximas fases.

---

# Fase 2 — Workloads de laboratório

### Objetivo

Criar os serviços que representarão os workloads reais do ambiente.

### Serviços

```text
customer-api
order-producer
order-consumer
```

### Customer API

Aplicação:

```text
Java 21
Spring Boot
Maven
```

Endpoints básicos:

```text
GET /api/customers
GET /actuator/health
GET /actuator/prometheus
```

### Kafka

Criar:

```text
order-producer
       │
       ▼
      Kafka
       │
       ▼
order-consumer
```

### Atividades

* [ ] Criar `customer-api`
* [ ] Criar `order-producer`
* [ ] Criar `order-consumer`
* [ ] Configurar Kafka
* [ ] Criar tópico de pedidos
* [ ] Implementar produção de mensagens
* [ ] Implementar consumo de mensagens
* [ ] Criar Dockerfiles
* [ ] Gerar imagens Docker
* [ ] Executar aplicações localmente
* [ ] Validar fluxo HTTP
* [ ] Validar fluxo Kafka

### Critério de conclusão

Deve ser possível demonstrar:

```text
HTTP
Client → customer-api → Response
```

e:

```text
Producer → Kafka → Consumer
```

---

# Fase 3 — Kubernetes + Helm + GitOps

### Objetivo

Executar os serviços no Kubernetes e estabelecer o primeiro fluxo GitOps.

### Tecnologias

* Kubernetes
* Helm
* Argo CD

### Atividades

* [ ] Criar Deployment da `customer-api`
* [ ] Criar Service
* [ ] Configurar ConfigMap
* [ ] Configurar Secret
* [ ] Configurar readiness probe
* [ ] Configurar liveness probe
* [ ] Definir CPU/memory requests
* [ ] Definir CPU/memory limits
* [ ] Criar Helm Chart
* [ ] Criar `values.yaml`
* [ ] Criar Helm Charts dos demais serviços
* [ ] Instalar Argo CD
* [ ] Criar aplicação no Argo CD
* [ ] Configurar repositório GitOps
* [ ] Validar sincronização Git → Argo CD → Kubernetes

### Critério de conclusão

Um commit no repositório deve resultar em:

```text
Git
 ↓
Argo CD
 ↓
Kubernetes
 ↓
Workload atualizado
```

Sem necessidade de executar manualmente `kubectl apply`.

---

# Fase 4 — Observabilidade

### Objetivo

Criar a camada de observabilidade necessária para determinar atividade e utilização dos workloads.

### Tecnologias

* Prometheus
* Grafana
* Micrometer
* Spring Boot Actuator

### Métricas

Para APIs:

```text
HTTP requests
Request rate
Response status
Latency
CPU
Memory
Pod status
```

Para Kafka:

```text
Messages produced
Messages consumed
Consumer activity
Consumer lag
```

### Atividades

* [ ] Instalar Prometheus
* [ ] Instalar Grafana
* [ ] Configurar scraping da `customer-api`
* [ ] Expor métricas do Spring Boot
* [ ] Criar dashboard básico
* [ ] Observar requisições HTTP
* [ ] Observar utilização de recursos
* [ ] Observar Kafka
* [ ] Observar consumer lag
* [ ] Documentar métricas relevantes

### Critério de conclusão

Ser capaz de responder:

```text
Quantas requisições a API recebeu?

Quando houve atividade?

Qual o consumo de CPU?

Qual o consumo de memória?

O consumer Kafka está processando mensagens?

Existe backlog?
```

---

# Fase 5 — Autoscaling com KEDA

### Objetivo

Estudar autoscaling baseado em demanda e diferenciar autoscaling de gerenciamento de lifecycle.

### Tecnologias

* KEDA
* Kafka
* Prometheus

### Cenário

```text
Kafka
  │
  ▼
Consumer
  │
  ▼
KEDA
  │
  ▼
Deployment
```

### Atividades

* [ ] Instalar KEDA
* [ ] Criar ScaledObject
* [ ] Configurar autoscaling baseado em Kafka
* [ ] Gerar mensagens
* [ ] Observar aumento de replicas
* [ ] Consumir backlog
* [ ] Observar redução de replicas
* [ ] Testar scale-to-zero
* [ ] Avaliar KEDA baseado em métricas do Prometheus

### Critério de conclusão

Demonstrar:

```text
Kafka lag = 0
        ↓
poucas replicas

Kafka lag ↑
        ↓
replicas ↑

Kafka lag = 0
        ↓
replicas ↓
```

### Conceito importante

Nesta fase será validada a diferença entre:

```text
Autoscaling
```

e:

```text
Lifecycle Management
```

KEDA responde principalmente à demanda.

O Guardian será responsável pelas políticas de ciclo de vida e ociosidade.

---

# Fase 6 — Kube Dev Guardian MVP

### Objetivo

Construir o Guardian como uma aplicação Spring Boot responsável por detectar workloads ociosos e aplicar políticas de lifecycle.

### Arquitetura inicial

```text
┌────────────────────────────────────┐
│         Kube Dev Guardian          │
│                                    │
│  REST API                          │
│  Scheduler                         │
│  Activity Detection                │
│  Policy Engine                     │
│  Kubernetes Client                 │
│  Prometheus Client                 │
│  Audit                             │
└────────────────────────────────────┘
```

### Primeira implementação

O primeiro Activity Provider será HTTP.

```text
customer-api
     │
     ▼
Prometheus
     │
     ▼
Guardian
```

### Estados

```text
ACTIVE
   │
   ▼
IDLE
   │
   ▼
WARNING
   │
   ▼
SCHEDULED
   │
   ▼
SUSPENDED
   │
   ▼
ACTIVE
```

### Política inicial

Exemplo:

```text
< 24h sem atividade
→ ACTIVE

≥ 24h
→ WARNING

≥ 48h
→ SCHEDULED

≥ 72h
→ SUSPENDED
```

Os valores serão configuráveis.

### Atividades

* [ ] Criar projeto Spring Boot
* [ ] Criar Kubernetes Client
* [ ] Criar Prometheus Client
* [ ] Implementar discovery de workloads
* [ ] Implementar detecção de atividade HTTP
* [ ] Implementar cálculo de idle duration
* [ ] Implementar máquina de estados
* [ ] Implementar Policy Engine
* [ ] Implementar scheduler
* [ ] Implementar scale-to-zero
* [ ] Implementar restore
* [ ] Criar logs estruturados
* [ ] Criar audit trail

### Critério de conclusão

Demonstrar:

```text
API recebe requests
        ↓
ACTIVE

Sem requests
        ↓
IDLE

Tempo excedido
        ↓
WARNING

Tempo excedido
        ↓
replicas = 0
```

E conseguir reativar o serviço.

---

# Fase 7 — Governance & Security

### Objetivo

Garantir que a solução siga princípios mínimos de segurança e governança necessários para uma futura avaliação corporativa.

### Authentication

* [ ] Definir modelo de autenticação
* [ ] Avaliar OIDC
* [ ] Preparar integração com SSO corporativo

### Authorization

* [ ] Implementar autorização por usuário/time
* [ ] Restringir workloads por namespace
* [ ] Validar ownership
* [ ] Implementar RBAC

### Kubernetes Security

* [ ] Criar ServiceAccount exclusiva para Guardian
* [ ] Aplicar Least Privilege
* [ ] Criar Role/ClusterRole mínima
* [ ] Criar RoleBinding
* [ ] Evitar `cluster-admin`
* [ ] Configurar SecurityContext
* [ ] Executar containers como non-root
* [ ] Avaliar filesystem read-only

### Namespace Governance

* [ ] Criar namespace por time
* [ ] Configurar ResourceQuota
* [ ] Configurar LimitRange
* [ ] Definir requests/limits obrigatórios
* [ ] Definir limites de Pods
* [ ] Avaliar NetworkPolicy

### Secrets

* [ ] Não armazenar credenciais no código
* [ ] Não armazenar secrets em texto no Git
* [ ] Avaliar estratégia de Secret Management
* [ ] Documentar integração futura com Vault ou solução corporativa

### API Security

* [ ] Authentication
* [ ] Authorization
* [ ] Input validation
* [ ] Rate limiting
* [ ] Error handling seguro
* [ ] Não expor informações sensíveis
* [ ] Headers de segurança quando aplicável

### Audit

Registrar:

```text
User
Team
Namespace
Workload
Action
Timestamp
Reason
Result
```

Exemplo:

```json
{
  "user": "developer",
  "team": "team-a",
  "namespace": "team-a",
  "workload": "customer-api",
  "action": "SCALE_TO_ZERO",
  "reason": "IDLE_TIMEOUT",
  "result": "SUCCESS"
}
```

### Critério de conclusão

Demonstrar que:

```text
Developer
   ↓
Guardian
   ↓
Authorization
   ↓
Policy
   ↓
Kubernetes RBAC
   ↓
Action
   ↓
Audit
```

---

# Fase 8 — Developer Self-Service

### Objetivo

Permitir que o desenvolvedor gerencie seus próprios workloads sem acesso direto ao Kubernetes.

### API

Endpoints previstos:

```text
GET  /api/v1/services
GET  /api/v1/services/{service}
POST /api/v1/services/{service}/start
POST /api/v1/services/{service}/stop
POST /api/v1/services/{service}/keep-alive
```

### Fluxo

```text
Developer
    │
    ▼
Guardian API
    │
    ▼
Authentication
    │
    ▼
Authorization
    │
    ▼
Policy
    │
    ▼
Kubernetes API
```

### Funcionalidades

* [ ] Listar serviços do time
* [ ] Consultar status
* [ ] Consultar tempo de ociosidade
* [ ] Iniciar serviço
* [ ] Suspender serviço
* [ ] Solicitar Keep Alive
* [ ] Consultar histórico
* [ ] Validar autorização
* [ ] Registrar auditoria

### Critério de conclusão

O desenvolvedor deve conseguir:

```text
Ver serviço
    ↓
Ver que está suspenso
    ↓
START
    ↓
Pod criado
    ↓
Service READY
```

sem executar comandos `kubectl`.

---

# 5. Evoluções futuras

Após a conclusão do MVP, serão avaliadas novas capacidades.

## Activity Providers

Expandir o mecanismo de detecção:

```text
ActivityProvider
│
├── HTTP
├── Kafka
├── RabbitMQ
├── Scheduled Jobs
└── Custom Metrics
```

---

## Kubernetes Operator

Avaliar transformação das políticas em recursos Kubernetes.

Exemplo:

```yaml
apiVersion: guardian.dev/v1
kind: ManagedService

metadata:
  name: customer-api

spec:
  idlePolicy:
    warningAfter: 24h
    suspendAfter: 72h

  replicas:
    active: 1
    suspended: 0
```

---

## Resource Optimization

Evoluir de:

```text
Idle Detection
```

para:

```text
Resource Optimization
```

Possibilitando recomendações relacionadas a:

* CPU requests
* Memory requests
* CPU limits
* Memory limits
* Número de replicas
* Workloads ociosos
* Capacidade disponível

---

## IA

A IA será considerada como camada de assistência, e não como mecanismo de execução irrestrita.

Arquitetura:

```text
Developer
    │
    ▼
AI Assistant
    │
    ▼
Guardian Tools
    │
    ▼
Authorization
    │
    ▼
Policy Engine
    │
    ▼
Kubernetes
```

Possíveis capacidades:

```text
"Quais serviços meus estão desligados?"

"Por que meu serviço foi suspenso?"

"Suba o customer-api."

"Quais serviços do meu time estão ociosos?"

"Quais workloads estão consumindo recursos sem utilização?"
```

A IA não deverá possuir acesso direto e irrestrito à API do Kubernetes.

---

# 6. Segurança como requisito transversal

Segurança não será tratada como uma fase isolada.

Cada nova funcionalidade deverá considerar:

```text
Authentication
Authorization
Least Privilege
Secrets
Audit
Input Validation
Logging
Container Security
Dependency Security
Network Security
```

A implementação deverá evitar a criação de atalhos que dificultem uma futura avaliação de Segurança da Informação.

---

# 7. Princípios arquiteturais

A PoC seguirá os seguintes princípios:

### Least Privilege

Nenhum componente deve possuir mais privilégios que o necessário.

### Developer Self-Service

O desenvolvedor deve possuir autonomia sem receber acesso administrativo ao cluster.

### GitOps

Sempre que aplicável, o estado desejado das aplicações deve ser controlado através do Git.

### Automation First

Processos repetitivos devem ser automatizados.

### Auditability

Toda alteração realizada automaticamente ou por usuário deve ser rastreável.

### Policy Driven

As ações do Guardian devem ser determinadas por políticas configuráveis.

### Separation of Responsibilities

Separar:

```text
Observability
      ↓
Detection
      ↓
Policy
      ↓
Decision
      ↓
Action
```

### Fail Safe

Falhas do Guardian não devem resultar em comportamento destrutivo ou indiscriminado sobre os workloads.

---

# 8. Definition of Done da PoC

A PoC será considerada concluída quando for possível demonstrar o seguinte cenário de ponta a ponta:

```text
                  ┌──────────────┐
                  │ Developer    │
                  └──────┬───────┘
                         │
                         ▼
                    customer-api
                         │
                    HTTP Requests
                         │
                         ▼
                    Prometheus
                         │
                         ▼
                 Kube Dev Guardian
                         │
                  Idle Detection
                         │
                         ▼
                     Policy
                         │
              ┌──────────┴──────────┐
              │                     │
           Warning              Timeout
              │                     │
              │                     ▼
              │                Scale = 0
              │                     │
              └──────────┬──────────┘
                         │
                         ▼
                  Developer Self-Service
                         │
                         ▼
                       START
                         │
                         ▼
                    Service UP
```

Além disso:

* [ ] O workload possui métricas.
* [ ] O Guardian identifica sua atividade.
* [ ] O Guardian identifica ociosidade.
* [ ] A política de lifecycle é aplicada.
* [ ] O time recebe notificações.
* [ ] O workload pode ser suspenso automaticamente.
* [ ] O desenvolvedor pode reativá-lo.
* [ ] A autorização é validada.
* [ ] As ações são auditadas.
* [ ] O Guardian utiliza RBAC de menor privilégio.
* [ ] Os namespaces possuem governança de recursos.
* [ ] O fluxo pode ser reproduzido no laboratório.
* [ ] A solução não depende de acesso `cluster-admin` pelo desenvolvedor.

---

# 9. Resultado esperado

Ao final da PoC, o projeto deverá demonstrar uma arquitetura de referência para gerenciamento de workloads Kubernetes não produtivos, combinando:

```text
Kubernetes
     +
Observability
     +
GitOps
     +
Autoscaling
     +
Lifecycle Management
     +
Resource Governance
     +
Security
     +
Developer Self-Service
```

O objetivo não é construir imediatamente uma solução produtiva completa, mas **validar tecnicamente os principais conceitos, identificar limitações e estabelecer uma base arquitetural para uma futura implementação corporativa.**

---

# 10. Status

🚧 **PoC — Em desenvolvimento**

A implementação será realizada de forma incremental. Cada fase deverá possuir um ambiente funcional e validado antes do início da próxima etapa.
