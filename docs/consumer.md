# Consumer de alertas

## Objetivo

Consumir o tópico `fraud-alerts` produzido pelo Flink e demonstrar o fluxo de leitura com `consumer group` e commit explícito do offset.

## Execução

Instale as dependências:

```bash
pip install -r requirements.txt
```

Configure as variáveis definidas em `.env.example` no ambiente local. Nunca publique credenciais no repositório.

Depois execute:

```bash
python src/consumer.py
```

## Decisão de commit

O exemplo usa `enable.auto.commit=false` e faz o commit depois de receber e tratar a mensagem. Isso deixa explícita a fronteira de processamento usada pelo projeto e evita marcar o evento como concluído antes do tratamento da aplicação.

O exemplo não implementa exatamente-once. Em caso de falha depois do efeito de negócio e antes do commit, pode ocorrer reprocessamento; uma aplicação real deve tornar o efeito idempotente ou implementar uma estratégia transacional adequada.

## Evidências

Registrar:

- consumer group utilizado;
- tópico `fraud-alerts`;
- mensagem recebida;
- partição e offset;
- confirmação do commit;
- comportamento após reiniciar o consumer, quando possível.

## Relação com o desafio

O consumer é a última etapa do caminho:

```text
PostgreSQL → CDC → Kafka → Flink SQL → fraud-alerts → Consumer
```
