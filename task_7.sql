-- task_7

/* По умолчанию сработает самая строгая блокировка, поскольку мы делаем команду ALTER*/

BEGIN;

ALTER TABLE cafe.managers ADD COLUMN number_of_row serial;

ALTER TABLE cafe.managers ADD COLUMN new_phones text[];

UPDATE cafe.managers
SET new_phones = ARRAY['8-800-2500-' || (99 + number_of_row)::text, phone];

ALTER TABLE cafe.managers DROP COLUMN phone;

ALTER TABLE cafe.managers DROP COLUMN number_of_row;

ALTER TABLE cafe.managers RENAME COLUMN new_phones TO phone;

COMMIT;
