# Roteiro de CDC

## Objetivo

Validar o caminho PostgreSQL → CDC → Confluent Cloud e produzir evidências para o README do projeto.

## Ordem de execução

1. Criar as tabelas com `scripts/01-create-database.sql`.
2. Inserir os dados sintéticos com `scripts/02-seed-payments.sql`.
3. Configurar o conector CDC no ambiente Confluent Cloud.
4. Confirmar que os tópicos correspondentes às tabelas foram criados e estão recebendo eventos.
5. Executar `scripts/03-test-cdc.sql` em três etapas: INSERT, UPDATE e DELETE.
6. Registrar uma evidência de cada operação no tópico correspondente.

## O que validar

### INSERT

Confirmar que a criação de um registro no PostgreSQL aparece como evento no Kafka.

### UPDATE

Confirmar que a alteração do pagamento chega ao tópico e identificar no envelope CDC como o valor anterior e o novo valor são representados.

### DELETE

Confirmar como o conector representa a exclusão. Dependendo da configuração, podem existir eventos de mudança e/ou tombstone.

## Evidências sugeridas

- captura do conector em estado saudável;
- captura do tópico recebendo o evento;
- evento de INSERT;
- evento de UPDATE;
- evento de DELETE;
- timestamp da execução;
- nomes reais dos tópicos e schemas.

## Segurança

Nunca registre API keys, secrets, senhas ou credenciais no README, nos scripts ou em commits. Use variáveis de ambiente e os mecanismos de secrets/configuração do Confluent Cloud.

## Observação

Os scripts usam um schema sintético para acelerar a preparação. Antes da execução no ambiente final, confirme compatibilidade com o dataset e com o envelope CDC fornecidos pelo desafio.
