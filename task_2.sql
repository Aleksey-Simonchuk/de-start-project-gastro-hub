-- task_2

CREATE MATERIALIZED VIEW cafe.annual_difference_cafes_avg_check_2017_2022 AS
WITH annual_checks AS (
	SELECT
		s.year,
		r.cafe_name,
		r.cafe_type,
		s.avg_check
	FROM (
		SELECT
			DISTINCT (EXTRACT (YEAR FROM report_date)) AS year,
			restaurant_uuid,
			ROUND(avg(avg_check) OVER (PARTITION BY EXTRACT (YEAR FROM report_date), restaurant_uuid), 2) AS avg_check
		FROM cafe.sales
		WHERE EXTRACT (YEAR FROM report_date) <> 2023
	) AS s
		LEFT JOIN cafe.restaurants r
		USING (restaurant_uuid)
	ORDER BY cafe_name, YEAR
)
SELECT
	year,
	cafe_name,
	cafe_type,
	avg_check AS report_year_avg_check,
	LAG (avg_check) OVER () AS last_year_avg_check,
	ROUND((1 - avg_check / LAG (avg_check) OVER ()) * 100, 2) AS avg_check_difference_in_percent
FROM annual_checks;
