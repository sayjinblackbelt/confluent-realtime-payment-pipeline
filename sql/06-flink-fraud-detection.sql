-- Fraud rule from the challenge:
-- three transactions for the same card inside a 60-second window
-- generate an alert.

CREATE TABLE fraud_alerts (
    card_id STRING,
    window_start TIMESTAMP_LTZ(3),
    window_end TIMESTAMP_LTZ(3),
    transaction_count BIGINT,
    total_amount DECIMAL(18, 2)
) WITH (
    'connector' = 'confluent',
    'topic' = 'fraud-alerts',
    'value.format' = 'avro'
);

INSERT INTO fraud_alerts
SELECT
    card_id,
    window_start,
    window_end,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM TABLE(
    TUMBLE(TABLE enriched_payments, DESCRIPTOR(event_time), INTERVAL '60' SECOND)
)
GROUP BY card_id, window_start, window_end
HAVING COUNT(*) >= 3;
