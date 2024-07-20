/*
 * SQL_projekt.sql: čtvrtý projekt do Engeto Online Python Akademie
 * author: Martin Pokorný
 * email: pokornymartin2@gmail.com
 * discord: martin_pokorny86
*/

# Zdrojové datové sady

SELECT *
FROM czechia_payroll AS cpay;

/*
 * calculation_code:
 * 100	fyzický
 * 200	přepočtený
 * 
 * unit_code:
 * 200		Kč
 * 80403	tis. osob (tis. os.)
 * 
 * value_type_code:
 * 316	Průměrný počet zaměstnaných osob
 * 5958	Průměrná hrubá mzda na zaměstnance
*/

SELECT *
FROM czechia_payroll_calculation AS cpc;

SELECT *
FROM czechia_payroll_industry_branch AS cpib;

SELECT *
FROM czechia_payroll_unit AS cpu;

SELECT *
FROM czechia_payroll_value_type AS cpvt;

SELECT *
FROM czechia_price AS cp;

SELECT *
FROM czechia_price_category AS cpcat;

SELECT *
FROM czechia_region AS cr;

SELECT *
FROM czechia_district AS cd;

SELECT *
FROM countries AS c;

SELECT *
FROM economies AS e;

# přiřazení definic ke kódům do tabulky czechia_payroll

SELECT
	cpay.id, cpay.value, cpay.value_type_code, cpvt.name AS value_type_name,
	cpay.unit_code, cpu.name AS unit_name, cpay.calculation_code, cpc.name AS calculation_name, 
	cpay.industry_branch_code, cpib.name AS industry_branch_name, cpay.payroll_year, cpay.payroll_quarter 
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code;

# přepočtená průměrná hrubá mzda na zaměstnance v Česku ve vybraném sektoru a roce - pouze pro kontrolu dat

SELECT
	cpay.id, cpay.value, cpay.value_type_code, cpvt.name AS value_type_name,
	cpay.unit_code, cpu.name AS unit_name, cpay.calculation_code, cpc.name AS calculation_name, 
	cpay.industry_branch_code, cpib.name AS industry_branch_name, cpay.payroll_year, cpay.payroll_quarter 
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200 AND cpay.industry_branch_code = "E" AND cpay.payroll_year = "2021";

# přepočtená průměrná hrubá mzda na zaměstnance v Česku podle čtvrtletí jednotlivých let - podrobná tabulka (s kódy)

SELECT
	concat(cpay.payroll_year, '_', cpay.payroll_quarter) AS year_quarter, 
	cpay.payroll_year, cpay.payroll_quarter, cpay.value, cpay.value_type_code, cpvt.name AS value_type_name,
	cpay.unit_code, cpu.name AS unit_name, cpay.calculation_code, cpc.name AS calculation_name, 
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200
GROUP BY cpay.industry_branch_code, cpay.payroll_year, cpay.payroll_quarter;

# přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - zjednodušená tabulka

SELECT
	concat(cpay.payroll_year, '_', cpay.payroll_quarter) AS year_quarter,
	cpay.payroll_year, cpay.payroll_quarter, cpay.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200
GROUP BY cpay.industry_branch_code, cpay.payroll_year, cpay.payroll_quarter;

# průměrná hrubá mzda na zaměstnance (fyzické osoby) v Česku podle kvartálů jednotlivých let - zjednodušená tabulka

SELECT
	concat(cpay.payroll_year, '_', cpay.payroll_quarter) AS year_quarter,
	cpay.payroll_year, cpay.payroll_quarter, cpay.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 100
GROUP BY cpay.industry_branch_code, cpay.payroll_year, cpay.payroll_quarter;

# přiřazení definic ke kódům do tabulky czechia_price - podrobná tabulka

SELECT
	cpay.id, cpay.category_code, cpc.name AS category_name, cpay.value,
	cpc.price_value, cpc.price_unit, cpay.date_from, cpay.date_to,
	COALESCE (cpay.region_code, 'CZ0') AS region_code,
	COALESCE (cr.name, 'Czechia') AS region_name,
	YEAR(date_to) AS date_to_year,
	CASE 
		WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
		WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
		WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
		ELSE '4'
	END AS date_to_quarter
FROM czechia_price AS cpay
LEFT JOIN czechia_price_category AS cpc
	ON cpay.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cpay.region_code = cr.code
ORDER BY cpay.category_code, cpay.date_to, cpay.region_code ASC;

# přiřazení definic ke kódům do tabulky czechia_price - zjednodušená tabulka

SELECT
	CONCAT(YEAR(date_to), '_',
		CASE 
			WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
			WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
			WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
			ELSE '4'
		END) AS year_quarter,
	YEAR(date_to) AS date_to_year,
	CASE 
		WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
		WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
		WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
		ELSE '4'
	END AS date_to_quarter,
	cpay.date_from, cpay.date_to,
	cpay.category_code, cpc.name AS category_name, cpay.value,
	COALESCE (cpay.region_code, 'CZ0') AS region_code,
	COALESCE (cr.name, 'Czechia') AS region_name,
	cpc.price_value, cpc.price_unit
FROM czechia_price AS cpay
LEFT JOIN czechia_price_category AS cpc
	ON cpay.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cpay.region_code = cr.code
ORDER BY cpay.category_code, cpay.date_to, cpay.region_code ASC;