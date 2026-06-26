-- task_4

WITH pizzas_set AS (
	SELECT
		cafe_name,
		jsonb_object_keys(menu -> 'Пицца') AS pizzas
	FROM cafe.restaurants
	WHERE cafe_type = 'pizzeria'
)
SELECT
	cafe_name,
	pizzas_cnt
FROM (
	SELECT
		cafe_name,
		count(pizzas) AS pizzas_cnt,
		RANK () OVER (ORDER BY count(pizzas) DESC) AS rating
	FROM pizzas_set
	GROUP BY cafe_name
) AS pizzas_scores
WHERE rating = 1;
