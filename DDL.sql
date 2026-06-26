-- создаём схему в базе данных, в которой будут хранится все таблицы

CREATE SCHEMA IF NOT EXISTS cafe;

/* создаём перечисляемый тип данных с типом заведения
для исключения ошибок при вводе новых данных*/

CREATE TYPE cafe.restaurant_type AS ENUM
	('coffee_shop', 'restaurant', 'bar', 'pizzeria');

-- создаём таблицу с информацией о заведениях

CREATE TABLE IF NOT EXISTS cafe.restaurants (
	restaurant_uuid uuid PRIMARY KEY DEFAULT GEN_RANDOM_UUID(), -- уникальный идентификатор заведения
	cafe_name CHARACTER VARYING NOT NULL, -- название заведения
	cafe_type cafe.restaurant_type NOT NULL, -- тип заведения
	menu JSONB NOT NULL -- меню заведения
);

-- создаём таблицу с информацией о менеджерах

CREATE TABLE IF NOT EXISTS cafe.managers (
	manager_uuid uuid PRIMARY KEY DEFAULT GEN_RANDOM_UUID(), -- уникальный идентификатор менеджера
	name CHARACTER VARYING NOT NULL, -- ФИО менеджера заведения
	phone VARCHAR(20) NOT NULL -- телефон менеджера заведения
);

-- создаём таблицу с информацией о датах приёма на работу и увольнения/перевода менеджера

CREATE TABLE IF NOT EXISTS cafe.restaurant_manager_work_dates (
	restaurant_uuid uuid REFERENCES cafe.restaurants, -- уникальный идентификатор заведения
	manager_uuid uuid REFERENCES cafe.managers, -- уникальный идентификатор менеджера
	employment_date DATE NOT NULL DEFAULT CURRENT_DATE, -- дата начала работы менеджера в заведении
	layoff_date DATE, -- дата окончания работы менеджера в заведении
	PRIMARY KEY (restaurant_uuid, manager_uuid)
);

-- создаём таблицу с информацией о среднем чеке в заведении на определённую дату

CREATE TABLE IF NOT EXISTS cafe.sales (
	report_date DATE NOT NULL DEFAULT CURRENT_DATE, -- дата отчёта
	restaurant_uuid uuid REFERENCES cafe.restaurants, -- уникальный идентификатор заведения
	avg_check NUMERIC(6, 2) NOT NULL DEFAULT 0 CHECK (avg_check >= 0), -- средний чек
	PRIMARY KEY (report_date, restaurant_uuid)
);
