-- NEXA / Confluent Real-Time Payment Pipeline
-- Modelo local de referência para preparar o desafio antes da execução no Confluent Cloud.

CREATE TABLE IF NOT EXISTS accounts (
    account_id BIGSERIAL PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    account_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    account_created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cards (
    card_id BIGSERIAL PRIMARY KEY,
    account_id BIGINT NOT NULL REFERENCES accounts(account_id),
    card_token VARCHAR(100) NOT NULL UNIQUE,
    card_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id BIGSERIAL PRIMARY KEY,
    account_id BIGINT NOT NULL REFERENCES accounts(account_id),
    card_id BIGINT NOT NULL REFERENCES cards(card_id),
    amount NUMERIC(14,2) NOT NULL CHECK (amount > 0),
    currency CHAR(3) NOT NULL DEFAULT 'BRL',
    payment_status VARCHAR(20) NOT NULL DEFAULT 'APPROVED',
    payment_created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_payments_card_created
    ON payments(card_id, payment_created_at);

CREATE INDEX IF NOT EXISTS idx_payments_account_created
    ON payments(account_id, payment_created_at);
