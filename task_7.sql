-- task_7

/* Используем блокировку FOR NO KEY UPDATE, при которой пользователь с FOR KEY SHARE
 сможет читать данные строк, на которые наложена FOR NO KEY UPDATE,
 но никто данные в таблице изменить уже не сможет*/

BEGIN;

SELECT *
FROM cafe.managers
FOR NO KEY UPDATE
NOWAIT;

ALTER TABLE cafe.managers ADD COLUMN number_of_row serial;

ALTER TABLE cafe.managers ADD COLUMN new_phones text[];

UPDATE cafe.managers
SET new_phones = ARRAY['8-800-2500-' || (99 + number_of_row)::text, phone];

ALTER TABLE cafe.managers DROP COLUMN phone;

ALTER TABLE cafe.managers DROP COLUMN number_of_row;

ALTER TABLE cafe.managers RENAME COLUMN new_phones TO phone;

COMMIT;
