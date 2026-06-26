-- task_1

CREATE VIEW cafe.top_3_cafes_in_categories AS
WITH aa_checks AS (SELECT
	DISTINCT(restaurant_uuid),
	ROUND(avg(avg_check) OVER (PARTITION BY restaurant_uuid), 2) AS amount_avg_check
FROM cafe.sales
ORDER BY 2 DESC)
SELECT
	cafe_name,
	cafe_type,
	amount_avg_check
FROM (
	SELECT
		r.cafe_name,
		r.cafe_type,
		c.amount_avg_check,
		row_number() OVER (PARTITION BY cafe_type ORDER BY amount_avg_check DESC) AS rating
	FROM cafe.restaurants r LEFT JOIN aa_checks c USING(restaurant_uuid)
) AS full_rating
WHERE rating IN (1, 2, 3);
