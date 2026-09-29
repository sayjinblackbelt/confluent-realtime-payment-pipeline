-- Preparação do banco PostgreSQL local.
-- Execute primeiro schema.sql e depois seed.sql.
-- Exemplo:
--   psql -U postgres -d payments -f sql/schema.sql
--   psql -U postgres -d payments -f sql/seed.sql

SELECT current_database() AS database_name;
SELECT COUNT(*) AS accounts FROM accounts;
SELECT COUNT(*) AS cards FROM cards;
SELECT COUNT(*) AS payments FROM payments;
