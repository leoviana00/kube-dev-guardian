# Kube Dev Guardian

PoC para gerenciamento automatizado do ciclo de vida de workloads em ambientes Kubernetes não produtivos.

O projeto tem como objetivo estudar uma abordagem para identificar serviços ociosos, aplicar políticas de utilização de recursos e permitir que os próprios times realizem ações de **start/stop** dos serviços, reduzindo a intervenção manual do time de DevOps.

## Objetivos

* Detectar workloads sem atividade por determinado período.
* Monitorar utilização e disponibilidade dos serviços.
* Notificar os times sobre serviços ociosos.
* Automatizar a suspensão de workloads após um período definido.
* Permitir que os desenvolvedores reativem seus serviços.
* Estudar governança de recursos por namespace/time.
* Avaliar integração com Kubernetes, Prometheus, KEDA e Argo CD.
* Explorar futuramente recursos de IA para recomendações e self-service.

## Tecnologias

* Java / Spring Boot
* Kubernetes
* Docker
* Helm
* Argo CD
* Prometheus
* Grafana
* KEDA
* Apache Kafka
* GitOps

## Arquitetura da PoC

A PoC será composta por diferentes tipos de workloads para representar cenários comuns em ambientes não produtivos:

```text
                         Kube Dev Guardian
                                │
                ┌───────────────┴───────────────┐
                │                               │
          HTTP Workloads                  Messaging
                │                               │
         customer-api                Kafka Producer
                                                │
                                                ▼
                                              Kafka
                                                │
                                                ▼
                                         Kafka Consumer
                                                │
                                               KEDA
```

O Guardian será responsável pela identificação de atividade, aplicação das políticas de ciclo de vida e automação das ações sobre os workloads.

## Exemplo de ciclo de vida

```text
ACTIVE
  │
  │ período sem atividade
  ▼
IDLE
  │
  │ novo período
  ▼
WARNING
  │
  │ prazo expirado
  ▼
SUSPENDED
  │
  │ developer start
  ▼
ACTIVE
```

Exemplo de política:

```text
24h sem atividade → Notificação

48h sem atividade → Novo alerta

72h sem atividade → Suspender workload

Após suspensão   → Desenvolvedor pode reativar
```

Os tempos acima são apenas exemplos para a PoC e poderão ser configurados posteriormente.

## Laboratório

O laboratório será executado localmente utilizando Docker Desktop e Kubernetes.

A infraestrutura será implantada progressivamente utilizando Helm e Argo CD, permitindo estudar também o fluxo GitOps.

## Roadmap

* [ ] Preparar ambiente Kubernetes local
* [ ] Criar serviços Java/Spring Boot
* [ ] Criar Kafka Producer e Consumer
* [ ] Dockerizar aplicações
* [ ] Criar Helm Charts
* [ ] Configurar Argo CD
* [ ] Configurar Prometheus e Grafana
* [ ] Configurar KEDA
* [ ] Implementar detecção de atividade
* [ ] Implementar políticas de ociosidade
* [ ] Implementar notificações
* [ ] Implementar suspensão automática
* [ ] Implementar self-service para reativação
* [ ] Implementar RBAC e governança por namespace
* [ ] Avaliar Operator/CRD
* [ ] Avaliar integração com IA

## Status

🚧 Em desenvolvimento**

Este projeto é um laboratório para explorar conceitos de Kubernetes, GitOps, observabilidade, autoscaling e automação de workloads em ambientes não produtivos.
