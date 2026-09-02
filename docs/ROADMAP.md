# Kube Dev Guardian - Roadmap da PoC

## 1. Visão

O **Kube Dev Guardian** é uma PoC para estudar governança e gerenciamento automatizado do ciclo de vida de workloads Kubernetes em ambientes não produtivos.

A ideia é identificar workloads ociosos, aplicar políticas de lifecycle, notificar os times e, quando necessário, suspender serviços com `replicas = 0`.

Os desenvolvedores poderão reativar seus próprios serviços através de uma camada de self-service, sem acesso direto ao Kubernetes.

A PoC também aborda segurança, observabilidade, GitOps, autoscaling, governança, auditoria e, futuramente, Operator e IA.

---

## 2. Objetivo

Validar o fluxo:

```text
Workload
   ↓
Atividade
   ↓
Detecção de ociosidade
   ↓
Política
   ↓
Notificação
   ↓
Suspensão
   ↓
Self-Service
   ↓
Reativação
```

O processo deve ser **automatizado, seguro, auditável e controlado por políticas**.

---

## 3. Roadmap

| ID  | Feature                    | Status                    |
| --- | -------------------------- | ------------------------- |
| F01 | Local Kubernetes Lab       | ✅ Concluída               |
| F02 | Application Workloads      | ▶ Próxima                 |
| F03 | Kafka Messaging Lab        | ⏳ Pendente                |
| F04 | Helm Packaging             | ⏳ Pendente                |
| F05 | GitOps with Argo CD        | ⏳ Pendente                |
| F06 | Observability              | ⏳ Pendente                |
| F07 | KEDA Autoscaling           | ⏳ Pendente                |
| F08 | Guardian Core              | ⏳ Pendente                |
| F09 | Idle Detection             | ⏳ Pendente                |
| F10 | Lifecycle Policies         | ⏳ Pendente                |
| F11 | Notifications              | ⏳ Pendente                |
| F12 | Kubernetes Security        | ⏳ Pendente                |
| F13 | Resource Governance        | 🧪 Experimento antecipado |
| F14 | Developer Self-Service API | ⏳ Pendente                |
| F15 | Audit & Compliance         | ⏳ Pendente                |
| F16 | Self-Service UI            | ⏳ Pendente                |
| F17 | Kubernetes Operator        | ⏳ Pendente                |
| F18 | AI Assistant               | ⏳ Pendente                |

**Regra:** a execução seguirá a ordem das Features. Experimentos antecipados podem acontecer, mas serão formalizados na Feature correspondente.

---

# 4. Features

## F01 - Local Kubernetes Lab

Preparar o ambiente local da PoC.

* Docker Desktop
* Kind
* Kubernetes
* kubectl
* Helm
* Git
* Cluster com control-plane e workers
* Namespaces `kube-dev-guardian`, `team-a` e `team-b`
* ResourceQuota / LimitRange
* RBAC básico

**Status:** concluída.

---

## F02 - Application Workloads

Criar os workloads utilizados durante a PoC.

* `customer-api`
* `order-producer`
* `order-consumer`
* Java 21 / Spring Boot
* REST API
* Actuator
* Métricas Prometheus
* Testes
* Dockerfiles e imagens

**Próximo passo oficial:** criar o `customer-api`.

---

## F03 - Kafka Messaging Lab

Criar o fluxo básico de mensageria:

```text
order-producer → Kafka → order-consumer
```

Validar produção, consumo e backlog de mensagens.

---

## F04 - Helm Packaging

Empacotar os workloads com Helm.

* Charts
* `values.yaml`
* Requests / Limits
* Probes
* Configurações parametrizadas

---

## F05 - GitOps with Argo CD

Criar o fluxo:

```text
Git → Argo CD → Kubernetes
```

Validar deploy e atualização dos workloads através de commits.

---

## F06 - Observability

Criar a base de observabilidade.

* Prometheus
* Grafana
* Micrometer
* Actuator
* Métricas HTTP
* Métricas Kafka
* CPU / memória
* Consumer lag

O objetivo é conseguir identificar **atividade e utilização dos workloads**.

---

## F07 - KEDA Autoscaling

Estudar autoscaling baseado em demanda.

```text
Kafka → Consumer → KEDA → Deployment
```

Validar scale-up, scale-down e scale-to-zero.

**Conceito:** KEDA reage à demanda. O Guardian cuidará de ociosidade e lifecycle.

---

## F08 - Guardian Core

Criar a aplicação principal `kube-dev-guardian`.

* Java 21
* Spring Boot
* Kubernetes Client
* Prometheus Client
* Scheduler
* Modelo de domínio
* API inicial
* Logs estruturados

Endpoint inicial:

```text
GET /api/v1/services
```

---

## F09 - Idle Detection

Detectar workloads ociosos.

Primeiro provider:

```text
Workload → Prometheus → Guardian → Activity Detection
```

Inicialmente será considerada a atividade HTTP.

---

## F10 - Lifecycle Policies

Transformar o tempo de ociosidade em decisões.

```text
ACTIVE
   ↓
IDLE
   ↓
WARNING
   ↓
SCHEDULED
   ↓
SUSPENDED
```

Os thresholds deverão ser configuráveis.

---

## F11 - Notifications

Notificar os times sobre:

* Ociosidade
* Warning
* Suspensão
* Outras ações de lifecycle

Inicialmente:

```text
Guardian → Console / Webhook
```

---

## F12 - Kubernetes Security

Garantir que o Guardian opere com **Least Privilege**.

* ServiceAccount
* RBAC
* Roles / RoleBindings
* SecurityContext
* Non-root
* NetworkPolicy
* Secrets
* Validação com `kubectl auth can-i`

O Guardian não deverá utilizar `cluster-admin`.

---

## F13 - Resource Governance

Controlar o consumo dos times e workloads.

* Namespace por time
* ResourceQuota
* LimitRange
* Requests / Limits
* Limite de Pods
* Ownership e labels
* NetworkPolicy

**Experimento antecipado:** ResourceQuota já foi validada através do workload `resource-pressure`.

O experimento será formalizado durante a execução oficial da F13.

---

## F14 - Developer Self-Service API

Permitir que o desenvolvedor controle seus próprios serviços sem acesso direto ao Kubernetes.

```text
Developer
   ↓
Guardian API
   ↓
Authorization
   ↓
Policy
   ↓
Kubernetes
```

Operações previstas:

```text
GET  /api/v1/services
GET  /api/v1/services/{id}
POST /api/v1/services/{id}/start
POST /api/v1/services/{id}/stop
POST /api/v1/services/{id}/keep-alive
```

Ownership e autorização deverão ser validados antes de qualquer operação.

---

## F15 - Audit & Compliance

Registrar as ações realizadas pelo Guardian.

Informações mínimas:

```text
User
Team
Workload
Action
Timestamp
Reason
Result
Actor Type
```

Exemplo de origem:

```text
USER
SCHEDULER
POLICY
AI
```

---

## F16 - Self-Service UI

Criar uma interface simples para:

* Consultar serviços
* Ver status
* Ver tempo de ociosidade
* Iniciar serviço
* Suspender serviço
* Manter serviço ativo

```text
Developer → Web UI → Guardian API
```

---

## F17 - Kubernetes Operator

Avaliar uma evolução para Operator / CRD.

```text
ManagedService
      ↓
     CRD
      ↓
   Operator
      ↓
Guardian Policies
      ↓
 Kubernetes
```

**Não faz parte do MVP inicial.**

---

## F18 - AI Assistant

Avaliar IA como interface de operação.

```text
Developer
   ↓
AI
   ↓
Guardian Tools
   ↓
Authorization
   ↓
Policy
   ↓
Kubernetes
```

A IA **não terá acesso direto ao Kubernetes**.

Exemplos:

```text
"Quais serviços do meu time estão ociosos?"

"Suba o customer-api."

"Quais serviços serão suspensos hoje?"
```

---

# 5. Regra de execução

A PoC será executada **Feature por Feature**.

Cada Feature deverá possuir:

```text
Objetivo
Implementação
Testes
Evidências
Documentação
Commit
```

---

