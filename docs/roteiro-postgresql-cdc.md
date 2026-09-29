# 🧪 Roteiro de Evidências — PostgreSQL + CDC

Este documento orienta a execução da primeira parte prática do pipeline: preparar o PostgreSQL, gerar mudanças controladas e comprovar que o CDC captura `INSERT`, `UPDATE` e `DELETE`.

> **Importante:** este arquivo é um roteiro. Os resultados reais, timestamps, nomes dos tópicos e capturas de tela devem ser adicionados somente durante a execução no ambiente configurado.

## 1. Objetivo da etapa

Comprovar o caminho:

```text
PostgreSQL
   │
   ├── INSERT
   ├── UPDATE
   └── DELETE
        │
        ▼
       CDC
        │
        ▼
   Evento Kafka
```

A evidência precisa demonstrar que uma alteração feita no banco aparece como evento no pipeline de streaming.

---

## 2. Pré-requisitos

Antes de iniciar:

- PostgreSQL disponível;
- banco de pagamentos criado;
- tabelas de contas, cartões e pagamentos disponíveis;
- Confluent Cloud configurado;
- cluster Kafka disponível;
- credenciais separadas para escrita/leitura conforme o desenho do projeto;
- conector CDC disponível/configurado;
- nenhum segredo ou chave colocado no GitHub.

---

## 3. Preparar o banco

Executar os scripts do diretório `sql/` na ordem apropriada:

```text
schema.sql
    ↓
seed.sql
```

Depois validar:

```sql
SELECT COUNT(*) FROM accounts;
SELECT COUNT(*) FROM cards;
SELECT COUNT(*) FROM payments;
```

### Evidência E01 — Banco preparado

Registrar:

- captura de tela ou saída do terminal;
- data/hora da execução;
- quantidade de registros nas tabelas principais.

**Status:** ⬜ Pendente

---

## 4. Teste de INSERT

Inserir um novo pagamento controlado.

Exemplo de referência — adaptar aos campos reais do schema:

```sql
INSERT INTO payments (
    account_id,
    card_id,
    amount,
    currency,
    payment_status,
    payment_created_at
) VALUES (
    1,
    1,
    150.00,
    'BRL',
    'APPROVED',
    CURRENT_TIMESTAMP
);
```

Depois consultar:

```sql
SELECT *
FROM payments
ORDER BY payment_id DESC
LIMIT 1;
```

Em seguida, localizar o evento correspondente no tópico produzido pelo CDC.

### Evidência E02 — INSERT → evento

Guardar:

- comando/consulta executada;
- registro criado no PostgreSQL;
- evento correspondente no Kafka/Confluent Cloud;
- tópico e partição;
- offset, quando disponível.

**Status:** ⬜ Pendente

---

## 5. Teste de UPDATE

Selecionar o pagamento criado no teste anterior e alterar um campo.

Exemplo:

```sql
UPDATE payments
SET payment_status = 'REVIEW'
WHERE payment_id = <ID_DO_PAGAMENTO>;
```

Validar:

```sql
SELECT *
FROM payments
WHERE payment_id = <ID_DO_PAGAMENTO>;
```

Depois localizar o evento correspondente produzido pelo CDC.

### Evidência E03 — UPDATE → evento

Guardar:

- valor anterior;
- alteração realizada;
- valor posterior;
- evento CDC correspondente;
- tópico/partição/offset quando disponíveis.

**Status:** ⬜ Pendente

---

## 6. Teste de DELETE

Somente depois de preservar as evidências anteriores, excluir o registro de teste:

```sql
DELETE FROM payments
WHERE payment_id = <ID_DO_PAGAMENTO>;
```

Validar:

```sql
SELECT *
FROM payments
WHERE payment_id = <ID_DO_PAGAMENTO>;
```

O resultado esperado da consulta é ausência do registro. Em seguida, verificar o evento correspondente no fluxo CDC.

### Evidência E04 — DELETE → evento

Guardar:

- comando executado;
- confirmação da exclusão no PostgreSQL;
- evento CDC correspondente;
- tópico/partição/offset quando disponíveis.

**Status:** ⬜ Pendente

---

## 7. O que observar no evento CDC

Durante a validação, registrar exatamente os campos fornecidos pelo conector utilizado. Não assumir previamente um formato que ainda não foi observado.

Registrar, quando disponíveis:

- operação (`INSERT`, `UPDATE`, `DELETE` ou equivalente);
- chave do registro;
- payload antes/depois, conforme o formato do conector;
- timestamp;
- tópico;
- partição;
- offset;
- headers/metadados relevantes.

### Evidência E05 — Anatomia do evento

Selecionar pelo menos um evento e documentar sua estrutura.

**Status:** ⬜ Pendente

---

## 8. Validação do caminho completo

Depois dos três testes individuais, executar um cenário completo:

```text
INSERT pagamento
      ↓
CDC
      ↓
Kafka
      ↓
Flink
      ↓
regra de fraude
      ↓
fraud-alerts
      ↓
Consumer
```

O objetivo desta etapa ainda não é provar a fraude; é comprovar que a camada de origem e CDC entrega dados corretamente para a próxima camada.

### Evidência E06 — CDC entregando ao pipeline

Registrar uma captura que permita relacionar:

```text
registro no PostgreSQL
        ↕
evento produzido pelo CDC
        ↕
tópico Kafka
```

**Status:** ⬜ Pendente

---

## 9. Checklist da etapa

| Item | Evidência | Status |
|---|---|---|
| PostgreSQL preparado | E01 | ⬜ |
| INSERT capturado | E02 | ⬜ |
| UPDATE capturado | E03 | ⬜ |
| DELETE capturado | E04 | ⬜ |
| Estrutura do evento documentada | E05 | ⬜ |
| CDC entregando ao pipeline | E06 | ⬜ |
| Credenciais protegidas | — | ⬜ |
| Nenhum `.env` versionado | — | ⬜ |

---

## 10. Regras para o registro das evidências

1. Não fabricar resultados.
2. Não substituir evidência real por código ou descrição.
3. Registrar os nomes reais dos tópicos criados pelo ambiente.
4. Registrar os offsets observados quando forem relevantes.
5. Não publicar API keys, secrets, senhas ou arquivos `.env`.
6. Preferir capturas que mostrem contexto suficiente para comprovar cada etapa.
7. Depois da execução, substituir os itens `⬜ Pendente` pelos resultados reais.

## 11. Próxima etapa

Com o CDC validado, avançar para:

```text
Schema Registry
      ↓
Contrato do evento
      ↓
Teste de evolução do schema
      ↓
Flink SQL
```

A configuração definitiva só deve ser registrada no projeto depois de ser executada e validada no Confluent Cloud.
