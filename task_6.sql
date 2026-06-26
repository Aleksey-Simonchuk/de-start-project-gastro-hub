-- task_6

/* Используем блокировку FOR UPDATE
 потому что FOR NO KEY UPDATE совместима с FOR KEY SHARE
 и блокировка с режимом FOR KEY SHARE сможет читать данные строк,
 на которые наложена FOR NO KEY UPDATE*/

BEGIN;

SELECT *
FROM cafe.restaurants
WHERE menu -> 'Кофе' -> 'Капучино' IS NOT NULL
FOR UPDATE
NOWAIT;

UPDATE cafe.restaurants
SET menu = jsonb_set(menu, '{Кофе, Капучино}', (((menu -> 'Кофе' -> 'Капучино')::numeric * 1.2)::text)::jsonb)
WHERE menu -> 'Кофе' -> 'Капучино' IS NOT NULL;

COMMIT;
