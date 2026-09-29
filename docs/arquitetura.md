# Arquitetura

## Visão geral

O projeto implementa um pipeline de dados em tempo real para pagamentos.

```text
PostgreSQL
   │
   │ CDC
   ▼
Confluent Cloud / Kafka
   │
   ├── Schema Registry
   │
   ▼
Flink SQL
   │
   ├── enriquecimento
   └── detecção de fraude
   │
   ▼
Tópico de alertas
   │
   ▼
Consumer
```

## Camadas

### 1. Fundação

Ambiente, cluster e identidades de acesso para produtores e consumidores.

### 2. Contrato

Schema Registry para definir e validar o formato dos eventos e testar evolução do schema.

### 3. Ingestão

CDC captura alterações realizadas no PostgreSQL e as disponibiliza como eventos no Kafka.

### 4. Processamento

Flink SQL processa os eventos, combina informações necessárias e aplica a regra de fraude definida no desafio.

### 5. Operação

Serão registradas métricas, evidências de acesso e custo da execução.

## Regra principal

Três transações no mesmo cartão em uma janela de 60 segundos devem gerar um alerta.

> A configuração concreta de tópicos, schemas, conectores e consultas será preenchida durante a execução no Confluent Cloud. Este documento não inventa parâmetros que ainda não foram validados no ambiente.
