/*
 * Otázka č. 5: Má výška HDP vliv na změny ve mzdách a cenách potravin?
 */

SELECT
	e.country, e.`year`, e.GDP,
	((LEAD(e.GDP, 1) OVER (ORDER BY e.`year`) / (e.GDP)) * 100) - 100 AS gdp_next_vs_previous_pct
FROM economies AS e
WHERE country = 'Czech Republic' AND e.YEAR >= 1990
ORDER BY e.`year` ASC;

# pro analýzu dat vlivu meziročního nárůstu hdp a mezd používám tabulku B z řešení čtvrté otázky:

# Tabulka B: přepočtená průměrná hrubá mzda na zaměstnance v Česku podle čtvrtletí jednotlivých let - zjednodušená tabulka

SELECT
	cpay.payroll_year,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name,
	round(avg(cpay.value),0) AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	((LEAD(AVG(cpay.value), 1) OVER (ORDER BY cpay.payroll_year) / AVG(cpay.value)) * 100) - 100 AS next_vs_previous_pct, 
	e.YEAR AS gdp_year, e.country,
	((LEAD(e.GDP, 1) OVER (ORDER BY e.`year`) / (e.GDP)) * 100) - 100 AS gdp_next_vs_previous_pct
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
LEFT JOIN economies AS e 
	ON cpay.payroll_year = e.`year` 
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200 AND cpay.industry_branch_code IS NULL AND e.country = 'Czech Republic'
GROUP BY cpay.industry_branch_code, cpay.payroll_year;

# pro analýzu dat vlivu meziročního nárůstu hdp a cen potravin používám tabulku "finální kód" z řešení třetí otázky:

SELECT 
    category_row_nr,
    date_to_year, 
    category_code, 
    category_name, 
    price_value, 
    price_unit, 
    average_year_price, 
    next_vs_previous_pct
FROM (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) AS category_row_nr,	
		YEAR(cp.date_to) AS date_to_year, 
		cp.category_code, cpc.name AS category_name, 
		cpc.price_value, cpc.price_unit,
		ROUND(AVG(cp.value), 2) AS average_year_price,
		CASE 
			WHEN ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) BETWEEN 1 AND 12 
			AND CONCAT(YEAR(cp.date_to), '_', cp.category_code, '_', ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to)) != '2018_212101_4'
			THEN ROUND(((LEAD(AVG(cp.value), 1) OVER (ORDER BY cp.category_code) / AVG(cp.value)) * 100),2) - 100
			ELSE NULL 
		END AS next_vs_previous_pct
	FROM czechia_price AS cp
	LEFT JOIN czechia_price_category AS cpc
		ON cp.category_code = cpc.code
	LEFT JOIN czechia_region AS cr
		ON cp.region_code = cr.code
	GROUP BY cp.category_code, YEAR(cp.date_to)
) sub
	ORDER BY  
    	next_vs_previous_pct IS NULL,
		next_vs_previous_pct, 
    	category_code, 
    	date_to_year;