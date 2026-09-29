# Operação final

## 1. Evidências da arquitetura

- [ ] PostgreSQL criado e populado.
- [ ] Connector CDC em estado saudável.
- [ ] INSERT observado no Kafka.
- [ ] UPDATE observado no Kafka.
- [ ] DELETE observado no Kafka.
- [ ] Schema Registry com versão inicial.
- [ ] Evolução de schema validada.
- [ ] Flink source tables executadas.
- [ ] JOIN de enriquecimento validado.
- [ ] Regra de três transações em 60 segundos validada.
- [ ] `fraud-alerts` recebeu o alerta.
- [ ] Consumer recebeu o alerta.
- [ ] Commit do offset observado.

## 2. Segurança

- [ ] Nenhuma API key foi versionada.
- [ ] Nenhum secret foi versionado.
- [ ] `.env` permanece ignorado pelo Git.
- [ ] `.env.example` contém somente nomes de variáveis, sem credenciais reais.
- [ ] Acesso de producer e consumer foi separado quando aplicável.

## 3. Custos

Registrar no README final:

- ambiente/cluster utilizado;
- região;
- período aproximado em execução;
- recursos de Flink utilizados;
- connectors utilizados;
- armazenamento/retention relevante;
- custo observado no Confluent Cloud;
- horário em que os recursos foram desligados/excluídos.

Não estimar um valor como custo real sem consultar a tela de billing/usage do ambiente utilizado.

## 4. Reprodutibilidade

Outra pessoa deve conseguir identificar no README:

1. pré-requisitos;
2. configuração das variáveis;
3. criação do PostgreSQL;
4. configuração do CDC;
5. Schema Registry;
6. execução do Flink;
7. execução do consumer;
8. teste de fraude;
9. validação das evidências;
10. encerramento dos recursos.

## 5. Limpeza

Ao finalizar o desafio, remover/desligar os recursos de laboratório que não forem necessários. Confirmar que não existem connectors, jobs, clusters ou recursos pagos esquecidos em execução.
