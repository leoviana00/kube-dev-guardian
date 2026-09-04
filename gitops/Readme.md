# GitOps - kube-dev-guardian

Configuração de GitOps do projeto `kube-dev-guardian` utilizando Argo CD.

## Objetivo

Utilizar o Git como fonte de verdade para o estado desejado dos workloads Kubernetes.

O Argo CD monitora o repositório e realiza a reconciliação automática entre o estado definido no Git e o estado do cluster.

## Arquitetura

```text
GitHub
   |
   | Git
   v
Argo CD
   |
   | Helm
   v
Kubernetes
   |
   v
team-a
```

## Estrutura
```
gitops/
├── Readme.md
├── applications/
│   ├── order-producer.yaml
│   └── order-consumer.yaml
└── infrastructure/
```

## Argo CD

O Argo CD está instalado no namespace:
```
argocd
```

As Applications configuradas são:

```
order-producer
order-consumer
```

Ambas utilizam os Helm Charts existentes no projeto:

```
infrastructure/helm/order-producer
infrastructure/helm/order-consumer
```

## Repository

Repositório utilizado:

```
https://github.com/leoviana00/kube-dev-guardian.git
```

Branch utilizada durante o desenvolvimento da Feature:

```
FEATURE05-GITOPS-ARGOCD
```

## Sync Policy

As Applications utilizam sincronização automática:

```
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

Também está habilitada a criação automática do namespace:

```
syncOptions:
  - CreateNamespace=true
```

## Fluxo de Deploy

Uma alteração no Helm Chart segue o fluxo:

1. Alteração no Git
       |
2. Commit
       |
3. Push para GitHub
       |
4. Argo CD detecta alteração
       |
5. Argo CD renderiza o Helm Chart
       |
6. Kubernetes recebe o estado desejado
       |
7. Cluster converge para o estado declarado

## Validação

Foi realizado um teste alterando:

```
replicaCount: 1
```

para:

```
replicaCount: 2
```

O Argo CD detectou automaticamente a alteração e iniciou a reconciliação.

A segunda réplica não pôde ser criada porque a ResourceQuota do namespace team-a havia atingido seus limites de CPU e memória.

Após retornar:

```
replicaCount: 1
```

o Argo CD realizou novamente a reconciliação.

Estado final:

```
Application: Synced
Health:      Healthy
Deployment:  1/1
Pod:         Running
```

## Governança

O GitOps não substitui as políticas do Kubernetes.

As alterações reconciliadas pelo Argo CD continuam sujeitas a:

```
ResourceQuota;
LimitRange;
RBAC;
SecurityContext;
demais políticas aplicadas pelo cluster.
```

Isso garante que o processo de deployment permaneça subordinado às regras de governança definidas para o ambiente.

## Responsabilidades

1. Git

Define o estado desejado das aplicações.

2. Argo CD

Monitora o Git e realiza a reconciliação automática.

3. Helm

Empacota e parametriza os workloads Kubernetes.

4. Kubernetes

Executa os workloads e aplica as políticas do cluster.

5. Guardian

Nas Features futuras, será responsável pelo gerenciamento controlado do ciclo de vida dos workloads, sem substituir o GitOps.
