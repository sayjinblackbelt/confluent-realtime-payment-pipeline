# Schema Registry

## Objetivo

Registrar o contrato do evento de pagamento e demonstrar uma evolução compatível do schema antes do processamento no Flink.

## Arquivos

- `schemas/payments-value-v1.avsc` — contrato inicial.
- `schemas/payments-value-v2.avsc` — exemplo de evolução com `merchant_category` opcional e valor padrão `null`.

## Execução no Confluent Cloud

1. Criar ou selecionar o Schema Registry environment.
2. Confirmar o formato usado pelo tópico de pagamentos (Avro neste exemplo).
3. Registrar o schema inicial no subject correspondente ao tópico.
4. Confirmar a política de compatibilidade configurada no environment/subject.
5. Testar a publicação da versão 2.
6. Verificar se o Schema Registry aceita a evolução.
7. Registrar a evidência da versão e do resultado do teste.

## Evidências para o projeto

Capturar:

- subject do schema;
- versão inicial;
- versão 2;
- política de compatibilidade;
- resultado da validação/evolução;
- eventual mensagem de incompatibilidade quando um teste negativo for realizado.

## Teste positivo sugerido

A versão 2 adiciona um campo opcional com default `null`. Esse é o caso de evolução que deve ser validado segundo a política de compatibilidade configurada no ambiente.

## Teste negativo sugerido

Não altere o schema de produção apenas para provocar uma falha. Se for necessário demonstrar incompatibilidade, faça isso em um subject de teste ou registre o resultado de uma validação local apropriada.

## Segurança

Nenhuma API key, secret ou credencial deve aparecer nos schemas ou na documentação.
