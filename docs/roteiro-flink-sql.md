# ⚡ Roteiro de Evidências — Flink SQL e Detecção de Fraude

Esta etapa prepara o processamento em tempo real no Flink SQL depois que PostgreSQL, CDC, Kafka e Schema Registry estiverem validados.

> **Importante:** os nomes físicos das tabelas, campos e tópicos devem ser ajustados aos schemas observados no ambiente. O SQL abaixo é um modelo de implementação e não deve ser tratado como evidência de execução antes do teste real.

## 1. Objetivo

Implementar o fluxo:

```text
CDC / Kafka
    │
    ├── pagamentos
    │
    └── contas
          │
          ▼
      Flink SQL
          │
          ├── enriquecimento / JOIN
          │
          ├── agrupamento por cartão
          │
          ├── janela de 60 segundos
          │
          └── COUNT >= 3
                  │
                  ▼
             fraud-alerts
```

A documentação oficial do Confluent Cloud descreve janelas como uma forma de limitar agregações sobre streams infinitos a períodos finitos. Para operações baseadas em tempo, é necessário trabalhar com um atributo temporal adequado; em streaming, watermarks participam do avanço do event time. citeturn0search1turn0search2

---

## 2. Primeiro: descobrir o schema real

Antes de escrever a consulta final, validar:

- nome da tabela Kafka de pagamentos;
- nome da tabela Kafka de contas;
- nome e tipo da chave do pagamento;
- campo que identifica o cartão;
- campo temporal do evento;
- valor da transação;
- identificador da conta;
- campos necessários para o enriquecimento;
- tópico de destino dos alertas.

Não substituir esses valores por suposições no README final.

---

## 3. Criar as tabelas de origem no Flink

A estrutura conceitual será semelhante a:

```sql
CREATE TABLE payments (
    payment_id STRING,
    account_id STRING,
    card_id STRING,
    amount DECIMAL(18, 2),
    payment_status STRING,
    payment_created_at TIMESTAMP_LTZ(3),
    WATERMARK FOR payment_created_at AS payment_created_at - INTERVAL '5' SECOND
);
```

A definição real deve reproduzir os campos e tipos fornecidos pelo tópico/schema utilizado no projeto.

Para operações de janela, o campo temporal precisa ser um time attribute; a documentação do Confluent Cloud indica que campos de timestamp com `WATERMARK` podem atuar como atributos de tempo para essas operações. citeturn0search1

**Status:** ⬜ Pendente

---

## 4. Enriquecimento com contas

Se o cenário real disponibilizar uma tabela de contas, validar o relacionamento:

```text
payments.account_id
        │
        ▼
accounts.account_id
```

O resultado esperado é uma relação enriquecida contendo os dados necessários para o alerta.

Exemplo conceitual:

```sql
SELECT
    p.payment_id,
    p.card_id,
    p.account_id,
    p.amount,
    p.payment_created_at,
    a.account_status
FROM payments AS p
JOIN accounts AS a
  ON p.account_id = a.account_id;
```

A sintaxe final deve ser adaptada ao tipo de join e aos dados disponíveis no ambiente.

**Status:** ⬜ Pendente

---

## 5. Regra de fraude

### Regra do desafio

> Três transações no mesmo cartão em 60 segundos devem gerar um alerta.

A lógica precisa considerar:

```text
PARTITION BY card_id
        ↓
janela temporal de 60 segundos
        ↓
COUNT(*) >= 3
```

Uma alternativa adequada para agregação por janela é utilizar uma Window TVF, como `TUMBLE`. O Confluent Cloud documenta `TUMBLE`, `HOP`, `CUMULATE` e `SESSION` como funções de janela; uma agregação por janela utiliza `window_start` e `window_end` no `GROUP BY`. citeturn0search2turn0search4

### Modelo de consulta

```sql
SELECT
    card_id,
    window_start,
    window_end,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM TABLE(
    TUMBLE(
        TABLE payments,
        DESCRIPTOR(payment_created_at),
        INTERVAL '60' SECOND
    )
)
GROUP BY
    card_id,
    window_start,
    window_end
HAVING COUNT(*) >= 3;
```

> **Atenção:** uma janela `TUMBLE` de 60 segundos significa janelas fixas e não sobrepostas. Isso não é necessariamente idêntico à interpretação de “qualquer período móvel de 60 segundos”. Se o desafio exigir uma janela deslizante, a implementação deve ser ajustada para `HOP`. A escolha deve ser registrada no projeto conforme o comportamento exigido pela avaliação.

---

## 6. Caso a regra precise ser uma janela móvel

Para detectar três eventos dentro de qualquer intervalo de 60 segundos, uma abordagem com janela sobreposta pode ser mais apropriada.

Modelo conceitual:

```sql
SELECT
    card_id,
    window_start,
    window_end,
    COUNT(*) AS transaction_count
FROM TABLE(
    HOP(
        TABLE payments,
        DESCRIPTOR(payment_created_at),
        INTERVAL '10' SECOND,
        INTERVAL '60' SECOND
    )
)
GROUP BY
    card_id,
    window_start,
    window_end
HAVING COUNT(*) >= 3;
```

O tamanho do slide (`10 SECOND` no exemplo) deve ser definido conscientemente. Não registrar o exemplo como configuração final sem validar o requisito do desafio.

A documentação do Confluent Cloud confirma que HOP cria janelas sobrepostas e que um elemento pode pertencer a mais de uma janela. citeturn0search2

---

## 7. Criar o sink de alertas

O resultado deverá ser enviado para o tópico/tabela de saída escolhido para o projeto:

```text
fraud-alerts
```

Conceitualmente:

```sql
INSERT INTO fraud_alerts
SELECT
    card_id,
    window_start,
    window_end,
    transaction_count,
    total_amount
FROM fraud_detection;
```

No Flink SQL, `INSERT INTO` é utilizado para modificar dados e pode gravar resultados em uma sink table. citeturn0search7

A definição real da sink deve refletir o schema e o formato configurados no ambiente.

**Status:** ⬜ Pendente

---

## 8. Evidências do Flink

### E11 — Tabelas de origem

Comprovar que Flink consegue consultar os dados de pagamentos e contas.

**Status:** ⬜ Pendente

### E12 — JOIN / enriquecimento

Mostrar um resultado contendo dados do pagamento associados aos dados da conta.

**Status:** ⬜ Pendente

### E13 — Regra de fraude

Mostrar a consulta ou resultado que demonstre:

```text
card_id
COUNT >= 3
janela = 60 segundos
```

**Status:** ⬜ Pendente

### E14 — Alerta produzido

Mostrar o evento efetivamente chegando ao tópico `fraud-alerts` ou ao nome real definido no ambiente.

**Status:** ⬜ Pendente

### E15 — Pipeline funcionando de ponta a ponta

Comprovar:

```text
PostgreSQL
   ↓
CDC
   ↓
Kafka
   ↓
Flink SQL
   ↓
fraud-alerts
   ↓
Consumer
```

**Status:** ⬜ Pendente

---

## 9. Cenário mínimo de teste

Para produzir uma evidência clara, criar três pagamentos associados ao mesmo cartão dentro da janela definida:

```text
Cartão: CARD-TEST-001

T1 → 100,00
T2 → 150,00
T3 → 200,00
```

Os timestamps devem ser suficientemente próximos para satisfazer a janela escolhida.

Resultado esperado conceitualmente:

```text
card_id = CARD-TEST-001
transaction_count >= 3
fraud_alert = true / alerta emitido
```

O valor efetivamente produzido deve ser registrado a partir da saída real do Flink.

---

## 10. Checklist

| Item | Evidência | Status |
|---|---|---|
| Tabelas de origem acessíveis | E11 | ⬜ |
| JOIN funcionando | E12 | ⬜ |
| Regra de 3 transações / 60s | E13 | ⬜ |
| Evento em `fraud-alerts` | E14 | ⬜ |
| Pipeline ponta a ponta | E15 | ⬜ |

---

## 11. Pontos técnicos a observar

### Event time

Registrar qual timestamp representa o momento do evento e qual estratégia de watermark foi usada. A documentação do Confluent Cloud destaca que watermarks permitem ao Flink medir o progresso do event time e finalizar operações temporais. citeturn0search1

### Tumble × Hop

Não tratar as duas estratégias como equivalentes:

- `TUMBLE`: janelas fixas, sem sobreposição;
- `HOP`: janelas sobrepostas, adequadas quando a regra precisa considerar intervalos móveis.

citeturn0search2

### Estado

Agregações com janelas são stateful. O tamanho e a duração das janelas influenciam a quantidade de estado mantida pelo processamento. O Confluent Cloud possui mecanismos específicos para limites de estado em aplicações Flink. citeturn0search11

---

## 12. Próxima etapa

Depois que E11–E15 estiverem comprovadas:

```text
Flink validado
     ↓
Consumer
     ↓
Métricas / operação
     ↓
Custo
     ↓
README final
     ↓
Submissão do projeto
```
