# Arquitetura de Tópicos e Fluxo de Dados

## Visão geral

O pipeline foi desenhado para separar claramente **origem**, **eventos capturados por CDC**, **processamento em streaming** e **alertas de fraude**.

```text
PostgreSQL
   │
   │ CDC
   ▼
Confluent Cloud / Kafka
   │
   ├── payments
   │      │
   │      ▼
   │   Flink SQL
   │      │
   │      ├── enriquecimento com dados de conta/cartão
   │      │
   │      └── regra: ≥ 3 transações do mesmo cartão em 60 s
   │                         │
   │                         ▼
   │                    fraud-alerts
   │                         │
   │                         ▼
   │                     Consumer
   │
   └── tópicos CDC de entidades de apoio
       (accounts / cards, conforme a configuração final do conector)
```

> Os nomes finais dos tópicos gerados pelo CDC serão registrados após a configuração real do conector. O projeto não assume previamente um naming específico imposto pelo Confluent Cloud.

## Tópicos lógicos

| Tópico lógico | Origem | Função | Consumidor |
|---|---|---|---|
| `payments` | CDC/PostgreSQL | Eventos de pagamento | Flink SQL |
| `accounts` | CDC/PostgreSQL | Dados de contas para enriquecimento | Flink SQL |
| `cards` | CDC/PostgreSQL | Dados de cartões para enriquecimento e chave de negócio | Flink SQL |
| `fraud-alerts` | Flink SQL | Eventos classificados como suspeitos | Consumer |

## Chaves

A chave deve ser definida de acordo com a entidade cuja ordem de negócio precisa ser preservada.

Para o fluxo de fraude, a referência principal é o **cartão**. Assim, eventos relacionados ao mesmo cartão devem utilizar uma chave consistente, permitindo que o particionamento preserve a ordem dentro da partição.

A escolha definitiva da chave e o comportamento observado no ambiente serão registrados como evidência durante a execução.

## Consumer Groups

O princípio utilizado é:

```text
Tópico → Partições → Consumer Group
                         │
                         ├── Consumer A
                         ├── Consumer B
                         └── Consumer C
```

Dentro de um mesmo consumer group, cada partição é atribuída a no máximo um consumer por vez. Isso permite escalar o processamento adicionando consumers até o limite determinado pelo número de partições.

O consumer do projeto terá um `group.id` próprio, independente dos consumidores usados pelo Flink ou por outros processos.

## Fluxo por camada

### 1. PostgreSQL

O banco representa a origem transacional. Alterações de dados — incluindo `INSERT`, `UPDATE` e `DELETE` — serão capturadas pelo CDC.

### 2. CDC

O conector transforma alterações do banco em eventos de streaming. A evidência final deverá demonstrar pelo menos uma alteração de cada tipo exigido pelo desafio.

### 3. Kafka / Confluent Cloud

Os eventos são persistidos em tópicos e podem ser consumidos por aplicações independentes. O consumo não remove imediatamente o evento do tópico; retenção e política de limpeza determinam seu ciclo de vida.

### 4. Flink SQL

O Flink consome os eventos, realiza o enriquecimento e aplica a regra de negócio:

```text
COUNT(transações do mesmo cartão) >= 3
        dentro de 60 segundos
                ↓
         fraud-alerts
```

### 5. Consumer

O consumer lê `fraud-alerts` utilizando um `group.id` próprio e serve como evidência do resultado final do pipeline.

## Evidências a registrar

Durante a execução, preencher esta tabela com evidências reais:

| Etapa | Evidência |
|---|---|
| PostgreSQL criado | ⬜ |
| INSERT capturado | ⬜ |
| UPDATE capturado | ⬜ |
| DELETE capturado | ⬜ |
| Schema Registry | ⬜ |
| Evolução de schema | ⬜ |
| Tópico de pagamentos | ⬜ |
| Flink SQL executado | ⬜ |
| Regra de fraude acionada | ⬜ |
| Evento em `fraud-alerts` | ⬜ |
| Consumer recebendo alerta | ⬜ |
| Métricas | ⬜ |
| Custo | ⬜ |

## Decisões que ainda dependem da execução

Não serão inventados antes da configuração real:

- número final de partições;
- nomes físicos dos tópicos criados pelo CDC;
- configurações definitivas de retenção;
- configuração final do Schema Registry;
- configuração final do Flink;
- métricas observadas;
- custo efetivo do ambiente.

Esses dados serão adicionados ao README somente depois da validação no Confluent Cloud.
