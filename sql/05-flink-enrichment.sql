-- Enrich payment events with account information.
-- This query is intentionally kept separate from fraud detection so each
-- transformation can be demonstrated and validated independently.

CREATE TABLE enriched_payments (
    payment_id BIGINT,
    account_id BIGINT,
    customer_id BIGINT,
    card_id STRING,
    amount DECIMAL(18, 2),
    payment_status STRING,
    event_time TIMESTAMP_LTZ(3)
) WITH (
    'connector' = 'confluent',
    'topic' = 'enriched-payments',
    'value.format' = 'avro'
);

INSERT INTO enriched_payments
SELECT
    p.payment_id,
    p.account_id,
    a.customer_id,
    p.card_id,
    p.amount,
    p.payment_status,
    p.event_time
FROM payments_cdc AS p
JOIN accounts_cdc AS a
  ON p.account_id = a.account_id;
