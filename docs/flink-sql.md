# Flink SQL

## Objetivo

Transformar os eventos de pagamento em tempo real, enriquecer cada transação com os dados da conta e produzir um alerta quando houver pelo menos três transações do mesmo cartão dentro de uma janela de 60 segundos.

## Ordem de execução

1. Executar `sql/04-flink-source-tables.sql` e validar as tabelas-fonte.
2. Executar `sql/05-flink-enrichment.sql` e validar o tópico `enriched-payments`.
3. Executar `sql/06-flink-fraud-detection.sql` e validar o tópico `fraud-alerts`.
4. Gerar um cenário controlado com três eventos do mesmo `card_id` dentro da janela de 60 segundos.
5. Capturar a mensagem de alerta produzida.

## Arquitetura lógica

```text
payments CDC ─────┐
                   ├── JOIN account_id ──> enriched-payments
accounts CDC ─────┘                              │
                                                 ▼
                                      janela de 60 segundos
                                                 │
                                      COUNT(*) >= 3
                                                 │
                                                 ▼
                                          fraud-alerts
```

## Watermark

As tabelas-fonte usam uma tolerância de cinco segundos para eventos fora de ordem. Ajuste o valor ao comportamento real do dataset e documente a decisão na entrega final.

## Evidências

Capturar:

- definição das tabelas no Flink;
- resultado do JOIN/enriquecimento;
- três transações com o mesmo cartão dentro da janela;
- alerta produzido no tópico `fraud-alerts`;
- timestamp da execução;
- nome dos tópicos efetivamente utilizados.

## Atenção antes da execução

Os scripts são a implementação-base e devem ser validados contra a sintaxe e os conectores disponíveis no ambiente Confluent Cloud utilizado no desafio. Não assumir que os nomes de catálogo, connector options ou subjects são idênticos em todos os ambientes.

Não versionar credenciais ou API keys.
