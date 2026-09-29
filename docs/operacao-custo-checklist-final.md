# ⚙️ Operação, Custos e Checklist Final

Documento de preparação para a etapa final do projeto **Confluent Real-Time Payment Pipeline**.

> Este arquivo separa claramente o que será executado no ambiente real do que é apenas preparação. Valores de custo, métricas e evidências só devem ser preenchidos depois da execução.

## 1. Objetivo

Validar que o pipeline não apenas funciona tecnicamente, mas também pode ser observado, reproduzido, encerrado e explicado.

```text
PostgreSQL
    ↓
CDC
    ↓
Kafka / Schema Registry
    ↓
Flink SQL
    ↓
fraud-alerts
    ↓
Consumidor / evidência
```

---

## 2. Evidência E16 — Saúde do ambiente

Registrar no ambiente real:

- nome do Environment;
- nome do Kafka Cluster;
- região;
- status do cluster;
- tópicos existentes;
- conectores ativos;
- jobs/consultas Flink ativos.

```text
Environment: <preencher>
Kafka Cluster: <preencher>
Região: <preencher>
Status: <preencher>
```

**Status:** ⬜ Pendente

---

## 3. Evidência E17 — Métricas

Registrar as métricas relevantes durante a execução:

- throughput de produção;
- throughput de consumo;
- mensagens/eventos processados;
- latência, quando disponível;
- erros ou retries;
- estado dos conectores;
- estado do processamento Flink.

### Registro

| Métrica | Valor | Momento | Observação |
|---|---:|---|---|
| Produção | `<preencher>` | `<preencher>` | `<preencher>` |
| Consumo | `<preencher>` | `<preencher>` | `<preencher>` |
| Eventos processados | `<preencher>` | `<preencher>` | `<preencher>` |
| Latência | `<preencher>` | `<preencher>` | `<preencher>` |
| Erros | `<preencher>` | `<preencher>` | `<preencher>` |

**Status:** ⬜ Pendente

---

## 4. Evidência E18 — Segurança e acesso

Comprovar que o projeto utiliza identidades/secrets apropriados e que nenhum segredo foi versionado.

Verificar:

- credencial de escrita separada da credencial de leitura, quando aplicável;
- permissões compatíveis com cada componente;
- `.env` fora do Git;
- `.env.example` sem valores secretos;
- nenhuma API key, senha ou token no código;
- acesso público somente ao repositório/documentação, não às credenciais.

**Status:** ⬜ Pendente

---

## 5. Evidência E19 — Custo

Registrar o custo real observado no período de execução.

```text
Período: <preencher>
Custo observado: <preencher>
Moeda: <preencher>
Principais componentes de custo: <preencher>
```

### Componentes a verificar

- Kafka Cluster;
- Flink;
- Connectors/CDC;
- Schema Registry, conforme cobrança aplicável;
- armazenamento ou outros recursos utilizados;
- duração total do ambiente.

> Não estimar como custo real um valor calculado apenas por preço de tabela. Se for apresentada uma estimativa, identificá-la explicitamente como estimativa.

**Status:** ⬜ Pendente

---

## 6. Evidência E20 — Encerramento do ambiente

Demonstrar que os recursos podem ser encerrados depois do teste.

Checklist:

- [ ] parar/remover jobs Flink desnecessários;
- [ ] remover/desativar conectores temporários;
- [ ] revisar tópicos e recursos criados exclusivamente para o desafio;
- [ ] confirmar que nenhum recurso gerador de custo ficou ativo sem necessidade;
- [ ] registrar a forma de encerramento utilizada;
- [ ] preservar no GitHub somente os artefatos necessários para reprodução/documentação.

**Status:** ⬜ Pendente

---

# 7. Checklist técnico final

## Fundação

- [ ] Environment criado
- [ ] Kafka Cluster criado
- [ ] Identidade de produção configurada
- [ ] Identidade de consumo configurada
- [ ] Acessos testados

## Schema

- [ ] Schema inicial registrado
- [ ] Compatibilidade configurada/verificada
- [ ] Evolução de schema testada
- [ ] Evidências E07–E10 registradas

## CDC

- [ ] PostgreSQL preparado
- [ ] INSERT observado
- [ ] UPDATE observado
- [ ] DELETE observado
- [ ] Estrutura CDC documentada
- [ ] Evidências E01–E06 registradas

## Flink

- [ ] Fontes Kafka disponíveis
- [ ] Consulta Flink executada
- [ ] JOIN/enriquecimento validado
- [ ] Regra de fraude validada
- [ ] Tópico `fraud-alerts` produzido
- [ ] Evidências E11–E15 registradas

## Operação

- [ ] Saúde do ambiente registrada
- [ ] Métricas registradas
- [ ] Segurança revisada
- [ ] Custo registrado
- [ ] Recursos encerrados
- [ ] Evidências E16–E20 registradas

---

# 8. Checklist do README de entrega

Antes de submeter:

- [ ] README explica o problema e a arquitetura
- [ ] README mostra o fluxo completo do dado
- [ ] Cada camada possui evidência
- [ ] Não existem placeholders `<sua evidência aqui>`
- [ ] Não existem credenciais ou secrets versionados
- [ ] `.env.example` está presente quando necessário
- [ ] Instruções permitem reproduzir o projeto
- [ ] Instruções explicam como encerrar os recursos
- [ ] Custo está documentado como valor observado ou estimativa claramente identificada
- [ ] Links para evidências estão funcionando
- [ ] Repositório está público
- [ ] Nome do repositório está em minúsculas e sem acentos

---

# 9. Checklist de qualidade da evidência

Uma evidência útil deve responder a três perguntas:

1. **O que foi executado?**
2. **Qual resultado comprova que funcionou?**
3. **Onde esse resultado pode ser verificado?**

Priorizar evidências como:

- saída de comando;
- evento real consumido;
- consulta/result set do Flink;
- estado de connector/job;
- métrica do ambiente;
- captura de tela objetiva;
- trecho de configuração sem segredos.

Evitar capturas genéricas que não comprovem o comportamento do pipeline.

---

# 10. Estrutura final sugerida

```text
confluent-realtime-payment-pipeline/
├── README.md
├── .env.example
├── .gitignore
├── docs/
│   ├── roteiro-schema-registry.md
│   ├── roteiro-flink-sql.md
│   ├── operacao-custo-checklist-final.md
│   └── evidencias/
├── sql/
│   ├── sources.sql
│   ├── enrichment.sql
│   └── fraud-detection.sql
├── config/
│   └── ...
└── scripts/
    └── ...
```

Os nomes acima são uma estrutura de referência. Manter somente os arquivos que realmente forem utilizados pelo projeto.

---

# 11. Estado do projeto

| Bloco | Evidências | Estado |
|---|---|---|
| Fundação | E01–E06 | ⬜ Execução pendente |
| Schema Registry | E07–E10 | ⬜ Execução pendente |
| Flink SQL | E11–E15 | ⬜ Execução pendente |
| Operação | E16–E20 | ⬜ Execução pendente |
| README final | — | ⬜ Após execução |
| Submissão | — | ⬜ Após validação |

**Próximo passo prático:** configurar o ambiente do Confluent Cloud e executar as camadas na ordem, preenchendo as evidências conforme cada etapa for validada.