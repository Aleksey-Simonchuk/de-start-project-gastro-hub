-- task_5

WITH pizzerias_set AS (
SELECT
	cafe_name,
	(jsonb_each(menu)).key AS course_type,
	(jsonb_each(menu)).value AS course_set
FROM cafe.restaurants
WHERE cafe_type = 'pizzeria'
)
SELECT cafe_name, course_type, pizza_name, price
FROM (
	SELECT *, dense_rank() over(PARTITION BY cafe_name ORDER BY price DESC) AS rating
	FROM (
		SELECT
			cafe_name,
			course_type,
			(jsonb_each(course_set)).key AS pizza_name,
			(jsonb_each(course_set)).value::integer AS price
		FROM pizzerias_set
		WHERE course_type = 'Пицца'
		) AS pre_rating_data
) AS full_rating
WHERE rating = 1;
