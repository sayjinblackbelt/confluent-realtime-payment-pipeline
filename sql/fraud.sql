-- Regra de negócio do desafio:
-- três transações do mesmo cartão em uma janela de 60 segundos.
--
-- Esta versão é uma referência SQL para a implementação posterior no Flink SQL.
-- A sintaxe final deverá ser validada no ambiente Flink do Confluent Cloud.

SELECT
    card_id,
    COUNT(*) AS transaction_count,
    window_start,
    window_end
FROM TABLE(
    TUMBLE(TABLE payments, DESCRIPTOR(payment_created_at), INTERVAL '60' SECOND)
)
GROUP BY card_id, window_start, window_end
HAVING COUNT(*) >= 3;
