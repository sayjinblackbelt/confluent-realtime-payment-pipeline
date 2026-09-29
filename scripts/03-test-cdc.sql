-- CDC validation: execute each section separately and capture the resulting
-- event in Confluent Cloud as evidence.

-- 1) INSERT — should produce a create/insert change event.
INSERT INTO payments (payment_id, account_id, card_id, amount, payment_status)
VALUES (9101, 1001, 'CARD-CDC-01', 99.90, 'APPROVED');

-- 2) UPDATE — should produce an update change event.
UPDATE payments
SET amount = 109.90,
    payment_status = 'REVIEW',
    updated_at = CURRENT_TIMESTAMP
WHERE payment_id = 9101;

-- 3) DELETE — should produce a delete/tombstone-style CDC event according to
-- the connector's configured envelope and delete handling.
DELETE FROM payments
WHERE payment_id = 9101;

-- Evidence to capture:
-- * INSERT event;
-- * UPDATE event showing the changed value;
-- * DELETE event and the connector's representation of the deletion.
