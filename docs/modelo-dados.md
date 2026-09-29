# Modelo de dados

O projeto usa três entidades principais na preparação local:

- `accounts`: identifica a conta e o cliente.
- `cards`: associa um cartão a uma conta.
- `payments`: registra as transações financeiras.

## Chaves

- `account_id`: chave da conta.
- `card_id`: chave do cartão e candidato natural para a chave de particionamento dos eventos de pagamento quando a ordenação por cartão for necessária.
- `payment_id`: identificador único da transação.

## Regra de fraude

O desafio define um alerta quando existem **3 transações do mesmo cartão em 60 segundos**. A implementação final será executada no Flink SQL do Confluent Cloud e deverá ser validada com evidência real do ambiente.

## Observação

O schema Avro presente em `schemas/payment.avsc` é um rascunho de contrato para orientar a etapa de Schema Registry. A compatibilidade e a versão final serão validadas no Confluent Cloud durante a execução do projeto.
