-- наполняем данными таблицу restaurants

INSERT INTO cafe.restaurants (cafe_name, cafe_type, menu)
SELECT
	DISTINCT(m.cafe_name),
	s.type::cafe.restaurant_type,
	m.menu
FROM raw_data.menu m LEFT JOIN raw_data.sales s USING(cafe_name);

-- наполняем данными таблицу managers

INSERT INTO cafe.managers (name, phone)
SELECT
	DISTINCT(manager),
	manager_phone
FROM raw_data.sales
ORDER BY manager;

-- создаём представление для оптимизации ресурсов при заполнении следующих двух таблиц

CREATE VIEW raw_data.raw_to_cafe_with_uuids AS
	SELECT
		s.report_date AS report_date,
		s.avg_check AS avg_check,
		r.restaurant_uuid AS ruuid,
		m.manager_uuid AS muuid
	FROM raw_data.sales s
		LEFT JOIN cafe.restaurants r
		USING(cafe_name)
		LEFT JOIN cafe.managers m
		ON s.manager = m.name;

-- наполняем данными таблицу restaurant_manager_work_dates

INSERT INTO cafe.restaurant_manager_work_dates (
	restaurant_uuid, manager_uuid, employment_date, layoff_date
)
SELECT *
FROM (
	SELECT
		ruuid,
		muuid,
		min(report_date) AS min_date,
		max(report_date) AS max_date
	FROM raw_data.raw_to_cafe_with_uuids
	GROUP BY
		ruuid,
		muuid
) AS sub_query
GROUP BY ruuid, muuid, min_date, max_date
ORDER BY ruuid, muuid;

-- наполняем данными таблицу sales

INSERT INTO cafe.sales (report_date, restaurant_uuid, avg_check)
SELECT
	report_date,
	ruuid,
	avg_check
FROM raw_data.raw_to_cafe_with_uuids;
