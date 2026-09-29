-- PostgreSQL setup for the real-time payments pipeline
-- Run against the target PostgreSQL database.

CREATE TABLE IF NOT EXISTS accounts (
    account_id BIGINT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    account_status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id BIGINT PRIMARY KEY,
    account_id BIGINT NOT NULL REFERENCES accounts(account_id),
    card_id VARCHAR(64) NOT NULL,
    amount NUMERIC(18, 2) NOT NULL,
    payment_status VARCHAR(30) NOT NULL DEFAULT 'APPROVED',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_payments_card_created_at
    ON payments(card_id, created_at);

CREATE INDEX IF NOT EXISTS idx_payments_account_id
    ON payments(account_id);

-- CDC checklist:
-- * confirm logical replication/WAL prerequisites in the target environment;
-- * confirm the CDC connector's database user permissions;
-- * do not store connector credentials in this repository.
