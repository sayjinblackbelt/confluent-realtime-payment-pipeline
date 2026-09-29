-- Confluent Flink SQL source definitions.
-- Adjust topic names and schema/catalog identifiers to the actual
-- Confluent Cloud environment before execution.

CREATE TABLE payments_cdc (
    payment_id BIGINT,
    account_id BIGINT,
    card_id STRING,
    amount DECIMAL(18, 2),
    payment_status STRING,
    event_time TIMESTAMP_LTZ(3),
    WATERMARK FOR event_time AS event_time - INTERVAL '5' SECOND
) WITH (
    'connector' = 'confluent',
    'topic' = 'payments',
    'value.format' = 'avro'
);

CREATE TABLE accounts_cdc (
    account_id BIGINT,
    customer_id BIGINT,
    account_status STRING,
    updated_at TIMESTAMP_LTZ(3),
    WATERMARK FOR updated_at AS updated_at - INTERVAL '5' SECOND
) WITH (
    'connector' = 'confluent',
    'topic' = 'accounts',
    'value.format' = 'avro'
);
