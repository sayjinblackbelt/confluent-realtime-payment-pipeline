# ⚡ Confluent Real-Time Payment Pipeline

Pipeline de pagamentos em tempo real com **PostgreSQL, CDC, Confluent Cloud, Apache Kafka, Schema Registry e Flink SQL**, com enriquecimento de dados e detecção de transações suspeitas.

> Projeto desenvolvido como entrega prática do Bootcamp IBM Confluent — Dados em tempo real para agentes de IA.

## 🎯 Objetivo

Demonstrar, de ponta a ponta, o caminho de um dado de pagamento desde sua origem em PostgreSQL até o processamento em streaming e a geração de um alerta de fraude.

## 🏗️ Arquitetura

```text
PostgreSQL
    │
    │ CDC
    ▼
Confluent Cloud / Kafka
    │
    ├── payments ───────────────┐
    ├── accounts ──────────────┤
    └── cards ─────────────────┤
                               ▼
                           Flink SQL
                               │
                 enriquecimento + regra de fraude
                               │
                               ▼
                         fraud-alerts
                               │
                               ▼
                            Consumer
```

A documentação detalhada de tópicos, chaves, consumer groups e fluxo está em [`docs/arquitetura-topicos.md`](docs/arquitetura-topicos.md).

## 🔎 Cinco camadas

1. **Fundação** — ambiente, cluster e identidades separadas para escrita e leitura.
2. **Contrato** — Schema Registry e teste de evolução do schema.
3. **Ingestão** — CDC do PostgreSQL demonstrando `INSERT`, `UPDATE` e `DELETE`.
4. **Processamento** — Flink SQL, enriquecimento e regra de fraude.
5. **Operação** — métricas, acesso e custo.

## 🔄 Fluxo de produtores e consumidores

| Componente | Papel | Entrada | Saída |
|---|---|---|---|
| PostgreSQL | Origem transacional | Operações no banco | Alterações para CDC |
| CDC Connector | Producer de eventos de mudança | PostgreSQL | Tópicos Kafka |
| Flink SQL | Consumer + processador | Eventos de pagamentos e dados de apoio | `fraud-alerts` |
| Fraud Alerts | Tópico de saída | Resultado do Flink | Eventos de fraude |
| Consumer | Consumer final | `fraud-alerts` | Evidência do alerta |

### Regra de particionamento

A chave deve representar a entidade cuja ordem de negócio precisa ser preservada. Para a detecção de fraude, o cartão é a referência principal: eventos do mesmo cartão devem utilizar uma chave consistente para que sejam encaminhados de forma previsível para uma mesma partição.

### Consumer Groups

Cada aplicação consumidora terá seu próprio `group.id`. Dentro de um mesmo consumer group, cada partição é atribuída a no máximo um consumer por vez. O paralelismo efetivo depende do número de partições disponíveis.

## 🚨 Regra de fraude

**Três transações no mesmo cartão dentro de uma janela de 60 segundos geram um alerta de fraude.**

A consulta de referência está em [`sql/fraud.sql`](sql/fraud.sql). A sintaxe e o resultado definitivos serão validados no ambiente Flink do Confluent Cloud.

## 📁 Estrutura

```text
.
├── README.md
├── .env.example
├── .gitignore
├── docs/
│   ├── arquitetura.md
│   ├── arquitetura-topicos.md
│   └── evidencias/
├── schemas/
│   └── payment.avsc
├── sql/
│   ├── schema.sql
│   ├── seed.sql
│   └── fraud.sql
└── scripts/
```

## 🧩 Tecnologias

| Tecnologia | Função |
|---|---|
| PostgreSQL | Origem dos dados |
| CDC | Captura das mudanças |
| Apache Kafka | Eventos e streaming |
| Confluent Cloud | Plataforma gerenciada |
| Schema Registry | Contratos e evolução |
| Flink SQL | Processamento em tempo real |
| GitHub | Versionamento e portfólio |

## 🔐 Segurança

Credenciais e chaves não devem ser versionadas. O projeto usa `.env` localmente e mantém apenas `.env.example` no repositório.

## 📸 Evidências

Cada camada terá evidência verificável de execução: captura de tela, saída de comando, evento, resultado de consulta ou métrica. As evidências serão adicionadas em [`docs/evidencias/`](docs/evidencias/).

## ▶️ Execução

A documentação operacional final será preenchida após a configuração e validação do ambiente:

```text
1. Pré-requisitos
2. PostgreSQL
3. Confluent Cloud
4. Schema Registry
5. CDC
6. Flink SQL
7. Consumer
8. Validação ponta a ponta
9. Evidências
10. Limpeza dos recursos
```

## 💰 Custo

O custo real será registrado após a execução, considerando os recursos provisionados e o período de utilização.

## 📌 Status

| Etapa | Status |
|---|---|
| Repositório | 🟢 Criado |
| Estrutura inicial | 🟢 Em preparação |
| Arquitetura de tópicos | 🟢 Documentada |
| PostgreSQL | ⚪ Pendente |
| Confluent Cloud | ⚪ Pendente |
| Schema Registry | ⚪ Pendente |
| CDC | ⚪ Pendente |
| Flink SQL | ⚪ Pendente |
| Detecção de fraude | ⚪ Pendente |
| Consumer | ⚪ Pendente |
| Evidências | ⚪ Pendente |
| Custo | ⚪ Pendente |
| Entrega final | ⚪ Pendente |

## 📚 Conceitos consolidados

Event-Driven Architecture, eventos versus comandos, tópicos, partições, offsets, Consumer Groups, Producer e Consumer APIs, ordenação por chave, idempotência, semânticas `at-most-once`, `at-least-once` e `exactly-once`, retenção, compactação, CDC e streaming.

---

**Autor:** Filipe Gimenes de Morais
