-- Synthetic data for local CDC validation.
-- The values are intentionally small and deterministic.

INSERT INTO accounts (account_id, customer_id, account_status)
VALUES
    (1001, 501, 'ACTIVE'),
    (1002, 502, 'ACTIVE'),
    (1003, 503, 'ACTIVE')
ON CONFLICT (account_id) DO NOTHING;

INSERT INTO payments (payment_id, account_id, card_id, amount, payment_status)
VALUES
    (9001, 1001, 'CARD-001', 120.50, 'APPROVED'),
    (9002, 1002, 'CARD-002', 45.90, 'APPROVED'),
    (9003, 1001, 'CARD-001', 80.00, 'APPROVED'),
    (9004, 1003, 'CARD-003', 210.75, 'APPROVED')
ON CONFLICT (payment_id) DO NOTHING;

-- For the fraud rule, the weekend validation can insert at least
-- three additional events for the same card within 60 seconds.
-- Example:
-- INSERT INTO payments (payment_id, account_id, card_id, amount)
-- VALUES
--   (9010, 1001, 'CARD-FRAUD-01', 10.00),
--   (9011, 1001, 'CARD-FRAUD-01', 20.00),
--   (9012, 1001, 'CARD-FRAUD-01', 30.00);
