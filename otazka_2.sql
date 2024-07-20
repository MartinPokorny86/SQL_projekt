/*
 * Otázka č. 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 */

# category_code
# 114 201 - mléko polotučné pasterované
# 111 301 - chléb konzumní kmínový


SELECT
	CONCAT(YEAR(date_to), '_',
		CASE 
			WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
			WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
			WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
			ELSE '4'
		END, '_', 'CZ') AS year_quarter,
	YEAR(date_to) AS date_to_year,
	CASE 
		WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
		WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
		WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
		ELSE '4'
	END AS date_to_quarter,
	concat(DAY(cp.date_from), '.', MONTH(cp.date_from), '.', YEAR(cp.date_from)) AS date_from_edited, 
	concat(DAY(cp.date_to), '.', MONTH(cp.date_to), '.', YEAR(cp.date_to)) AS date_to_edited, DATEDIFF(cp.date_to, cp.date_from) AS number_of_days, 
	cp.category_code, cpc.name AS category_name, cp.value,
	COALESCE (cp.region_code, 'CZ0') AS region_code,
	COALESCE (cr.name, 'Czechia') AS region_name,
	cpc.price_value, cpc.price_unit, cpay.payroll_year, cpay.payroll_quarter, cpay.value AS avg_salary,
	concat(ROUND(cpay.value/cp.value,2),' ', cpc.price_unit) AS purchasing_power
FROM czechia_price AS cp
LEFT JOIN czechia_price_category AS cpc
	ON cp.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cp.region_code = cr.code
LEFT JOIN czechia_payroll AS cpay
	ON YEAR(cp.date_to) = cpay.payroll_year AND QUARTER(cp.date_to) = cpay.payroll_quarter
WHERE (concat(DAY(cp.date_to), '.', MONTH(cp.date_to), '.', YEAR(cp.date_to)) = '16.12.2018' OR 
concat(DAY(cp.date_to), '.', MONTH(cp.date_to), '.', YEAR(cp.date_to)) = '16.12.2007') AND 
(cp.category_code = 114201 OR cp.category_code = 111301) AND (region_code IS NULL) 
AND (cpay.value_type_code = 5958 AND cpay.calculation_code  = 200 AND cpay.industry_branch_code IS NULL)
ORDER BY cp.category_code, cp.date_to, cp.region_code ASC;