# Postup spuštění kódu "t_Martin_Pokorny_project_SQL_primary_final" (data mezd a cen potravin za Česko)

/*
 * Pro spuštění kódu "t_Martin_Pokorny_project_SQL_primary_final" je potřeba nejprve do localhostu vytvořit dvě tabulky
 * czechia_payroll_edited a czechia_price_edited. 
 */

# vytvoření tabulky czechia_payroll_edited

CREATE TABLE czechia_payroll_edited AS
SELECT
	concat(cpay.payroll_year, '_', cpay.payroll_quarter, '_', 'CZ') AS year_quarter,
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
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200 AND cpay.industry_branch_code IS NULL # tj. výběr mzdy za celé Česko, ne v rozdělení dle odvětví
GROUP BY cpay.industry_branch_code, cpay.payroll_year, cpay.payroll_quarter;

# vytvoření tabulky czechia_price_edited

CREATE TABLE czechia_price_edited AS
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
	cp.date_from, cp.date_to,
	cp.category_code, cpc.name AS category_name, cp.value,
	COALESCE (cp.region_code, 'CZ0') AS region_code,
	COALESCE (cr.name, 'Czechia') AS region_name,
	cpc.price_value, cpc.price_unit
FROM czechia_price AS cp
LEFT JOIN czechia_price_category AS cpc
	ON cp.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cp.region_code = cr.code
ORDER BY cp.category_code, cp.date_to, cp.region_code ASC;

/*
 * Vytvoření tabulky "t_Martin_Pokorny_project_SQL_primary_final"
 * Výpočet cenové dostupnosti potravin z přepočtené průměrné hrubé mzdy na zaměstnance v Česku celkem za období let 2006 - 2018 (čtvrtletně)
 */

SELECT *
FROM czechia_payroll_edited AS cpae;

SELECT *
FROM czechia_price_edited AS cpre;


CREATE TABLE t_Martin_Pokorny_project_SQL_primary_final AS 
SELECT
	cpre.year_quarter, cpre.date_from, cpre.date_to,
	cpre.category_code, cpre.category_name, cpre.value,
	cpre.region_code, cpre.region_name, cpre.price_value,
	cpre.price_unit, cpae.avg_salary, cpae.unit_name,
	cpae.value_type_name, cpae.calculation_name,
	ROUND ((cpre.value / cpae.avg_salary) *100 , 3) AS food_affordability_percent
FROM czechia_price_edited AS cpre
LEFT JOIN czechia_payroll_edited AS cpae
	ON cpre.year_quarter = cpae.year_quarter;
