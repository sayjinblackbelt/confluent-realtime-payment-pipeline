-- Dados sintéticos para testes locais.
-- A regra de fraude do desafio procura 3 transações do mesmo cartão em 60 segundos.

INSERT INTO accounts (customer_id) VALUES
    ('CUST-001'),
    ('CUST-002'),
    ('CUST-003');

INSERT INTO cards (account_id, card_token)
SELECT account_id, 'CARD-' || customer_id
FROM accounts;

-- Transações normais
INSERT INTO payments (account_id, card_id, amount, currency, payment_status, payment_created_at)
SELECT a.account_id, c.card_id, 120.00, 'BRL', 'APPROVED', CURRENT_TIMESTAMP - INTERVAL '10 minutes'
FROM accounts a
JOIN cards c ON c.account_id = a.account_id
WHERE a.customer_id = 'CUST-001';

INSERT INTO payments (account_id, card_id, amount, currency, payment_status, payment_created_at)
SELECT a.account_id, c.card_id, 85.50, 'BRL', 'APPROVED', CURRENT_TIMESTAMP - INTERVAL '5 minutes'
FROM accounts a
JOIN cards c ON c.account_id = a.account_id
WHERE a.customer_id = 'CUST-002';

-- Três transações do mesmo cartão dentro de uma janela de 60 segundos.
INSERT INTO payments (account_id, card_id, amount, currency, payment_status, payment_created_at)
SELECT a.account_id, c.card_id, 900.00, 'BRL', 'APPROVED', CURRENT_TIMESTAMP - INTERVAL '40 seconds'
FROM accounts a JOIN cards c ON c.account_id = a.account_id
WHERE a.customer_id = 'CUST-003';

INSERT INTO payments (account_id, card_id, amount, currency, payment_status, payment_created_at)
SELECT a.account_id, c.card_id, 750.00, 'BRL', 'APPROVED', CURRENT_TIMESTAMP - INTERVAL '25 seconds'
FROM accounts a JOIN cards c ON c.account_id = a.account_id
WHERE a.customer_id = 'CUST-003';

INSERT INTO payments (account_id, card_id, amount, currency, payment_status, payment_created_at)
SELECT a.account_id, c.card_id, 1100.00, 'BRL', 'APPROVED', CURRENT_TIMESTAMP - INTERVAL '10 seconds'
FROM accounts a JOIN cards c ON c.account_id = a.account_id
WHERE a.customer_id = 'CUST-003';
