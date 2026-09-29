# 📐 Roteiro de Evidências — Schema Registry e Evolução do Schema

Esta etapa valida o contrato dos eventos que circulam no pipeline e registra a evidência de uma evolução controlada do schema.

> **Importante:** nomes de subjects, versões e regras efetivamente aceitas devem ser registrados a partir do ambiente real. Este documento não antecipa resultados que ainda não foram executados.

## 1. Objetivo

Comprovar o caminho:

```text
Evento
  ↓
Schema Registry
  ↓
Validação do contrato
  ↓
Nova versão do schema
  ↓
Teste de compatibilidade
```

A avaliação do projeto deve demonstrar não apenas que um schema foi criado, mas que existe um contrato verificável e que uma alteração de campo é tratada de forma controlada.

---

## 2. O que será validado

- Registro do schema utilizado pelo evento;
- subject efetivamente criado pelo ambiente;
- formato e campos do evento;
- versão inicial do schema;
- alteração planejada de um campo;
- resultado da validação de compatibilidade;
- versão resultante, quando a alteração for aceita;
- comportamento quando a alteração não atender à política configurada.

---

## 3. Evidência E07 — Schema inicial

Depois que o tópico/subject estiver disponível, registrar:

- nome real do subject;
- formato utilizado (por exemplo, Avro, JSON Schema ou Protobuf, conforme a configuração adotada);
- versão inicial;
- campos principais;
- regra de compatibilidade configurada, quando disponível.

### Registro

```text
Subject: <preencher>
Formato: <preencher>
Versão: <preencher>
Compatibilidade: <preencher>
```

**Status:** ⬜ Pendente

---

## 4. Definir uma evolução controlada

A evolução deve ser simples e justificável.

Exemplo conceitual:

```text
Schema v1
─────────
payment_id
account_id
amount
payment_status

        ↓ evolução

Schema v2
─────────
payment_id
account_id
amount
payment_status
risk_score
```

O campo utilizado no teste deve ser compatível com o formato e com a regra de negócio escolhida para o projeto.

Não registrar esse exemplo como resultado real antes da execução.

---

## 5. Evidência E08 — Evolução aceita

Registrar o resultado real da tentativa de evolução:

- alteração realizada;
- versão anterior;
- nova versão, se aceita;
- resposta do Schema Registry;
- motivo pelo qual a alteração é compatível, quando aplicável.

**Status:** ⬜ Pendente

---

## 6. Evidência E09 — Teste de compatibilidade

Executar uma validação que permita demonstrar o comportamento da política de compatibilidade configurada.

Documentar:

```text
Política utilizada: <preencher>
Schema de origem: <preencher>
Schema proposto: <preencher>
Resultado: <aceito/rejeitado>
Motivo: <preencher>
```

Se for realizado um teste de alteração incompatível, registrar a rejeição e explicar qual regra foi violada.

**Status:** ⬜ Pendente

---

## 7. Evidência E10 — Evento validado pelo contrato

Depois da evolução, produzir ou observar um evento real e confirmar que o payload corresponde ao schema registrado.

Registrar:

- evento;
- subject;
- versão do schema, quando disponível;
- campos presentes;
- resultado da validação.

**Status:** ⬜ Pendente

---

## 8. Checklist

| Item | Evidência | Status |
|---|---|---|
| Schema inicial registrado | E07 | ⬜ |
| Evolução controlada realizada | E08 | ⬜ |
| Compatibilidade testada | E09 | ⬜ |
| Evento validado pelo contrato | E10 | ⬜ |
| Nenhum segredo versionado | — | ⬜ |

---

## 9. O que deve entrar no README final

Depois da execução, transformar as evidências em uma seção curta no README principal:

1. qual contrato foi adotado;
2. por que o schema existe;
3. qual mudança foi testada;
4. se a evolução foi aceita ou rejeitada;
5. qual evidência comprova o teste.

As capturas completas podem permanecer em `docs/evidencias/`, caso sejam adicionadas ao repositório.

---

## 10. Próxima etapa

Com o contrato validado:

```text
PostgreSQL
   ↓
CDC
   ↓
Schema Registry
   ↓
Kafka
   ↓
Flink SQL
   ↓
Regra de fraude
   ↓
fraud-alerts
```

A próxima documentação deverá preparar a execução e as evidências do **Flink SQL**, incluindo a regra de três transações do mesmo cartão em uma janela de 60 segundos.
