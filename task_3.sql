-- task_3

SELECT
	r.cafe_name,
	count(m.name) AS managers_have_worked
FROM cafe.restaurant_manager_work_dates rmwd
	LEFT JOIN cafe.restaurants r
	USING (restaurant_uuid)
	LEFT JOIN cafe.managers m
	USING (manager_uuid)
GROUP BY cafe_name
ORDER BY count(name) DESC
LIMIT 3;

/* В общем таких заведений не 3, а 8 и менеджеры в них менялись каждый год 30 ноября -
это больше похоже на какую то схему ротации в компании, поэтому требуется уточнённое ТЗ
для получения результата. */
