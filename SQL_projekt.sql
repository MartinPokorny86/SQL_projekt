/*
 * SQL_projekt.sql: čtvrtý projekt do Engeto Online Python Akademie
 * author: Martin Pokorný
 * email: pokornymartin2@gmail.com
 * discord: martin_pokorny86
*/

# Zdrojové datové sady

SELECT *
FROM czechia_payroll AS cp;

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
	cp.id, cp.value, cp.value_type_code, cpvt.name AS value_type_name,
	cp.unit_code, cpu.name AS unit_name, cp.calculation_code, cpc.name AS calculation_name, 
	cp.industry_branch_code, cpib.name AS industry_branch_name, cp.payroll_year, cp.payroll_quarter 
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code;

# přepočtená průměrná hrubá mzda na zaměstnance ve vybraném sektoru a roce - pouze pro kontrolu dat

SELECT
	cp.id, cp.value, cp.value_type_code, cpvt.name AS value_type_name,
	cp.unit_code, cpu.name AS unit_name, cp.calculation_code, cpc.name AS calculation_name, 
	cp.industry_branch_code, cpib.name AS industry_branch_name, cp.payroll_year, cp.payroll_quarter 
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code  = 200 AND cp.industry_branch_code = "E" AND cp.payroll_year = "2021";

# přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - podrobná tabulka (s kódy)

SELECT
	concat(cp.payroll_year, '_', cp.payroll_quarter) AS year_quarter, 
	cp.payroll_year, cp.payroll_quarter, cp.value, cp.value_type_code, cpvt.name AS value_type_name,
	cp.unit_code, cpu.name AS unit_name, cp.calculation_code, cpc.name AS calculation_name, 
	COALESCE (cp.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code  = 200
GROUP BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter;

# přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - zjednodušená tabulka

SELECT
	concat(cp.payroll_year, '_', cp.payroll_quarter) AS year_quarter,
	cp.payroll_year, cp.payroll_quarter, cp.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	COALESCE (cp.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code  = 200
GROUP BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter;

# průměrná hrubá mzda na zaměstnance (fyzické osoby) v Česku podle kvartálů jednotlivých let - zjednodušená tabulka

SELECT
	concat(cp.payroll_year, '_', cp.payroll_quarter) AS year_quarter,
	cp.payroll_year, cp.payroll_quarter, cp.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	COALESCE (cp.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code  = 100
GROUP BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter;

# přiřazení definic ke kódům do tabulky czechia_price - podrobná tabulka

SELECT
	cp.id, cp.category_code, cpc.name AS category_name, cp.value,
	cpc.price_value, cpc.price_unit, cp.date_from, cp.date_to,
	COALESCE (cp.region_code, 'CZ0') AS region_code,
	COALESCE (cr.name, 'Czechia') AS region_name,
	YEAR(date_to) AS date_to_year,
	CASE 
		WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
		WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
		WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
		ELSE '4'
	END AS date_to_quarter
FROM czechia_price AS cp
LEFT JOIN czechia_price_category AS cpc
	ON cp.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cp.region_code = cr.code
ORDER BY cp.category_code, cp.date_to, cp.region_code ASC;

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

SELECT *
FROM czechia_price_category AS cpcat;

SELECT *
FROM czechia_price AS cp;

SELECT *
FROM czechia_region AS cr;


# VYTVOŘENÍ DVOU TABULEK do mého localhost - czechia_payroll_edited a czechia_price_edited

# Vytvořena tabulka "czechia_payroll_edited"
# Tabulka vytvořena z kódu, který byl pod názvem: přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - zjednodušená tabulka

CREATE TABLE czechia_payroll_edited AS
SELECT
	concat(cp.payroll_year, '_', cp.payroll_quarter, '_', 'CZ') AS year_quarter,
	cp.payroll_year, cp.payroll_quarter, cp.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	COALESCE (cp.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code  = 200 AND cp.industry_branch_code IS NULL # tj. výběr mzdy za celé Česko, ne v rozdělení dle odvětví
GROUP BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter;

# Vytvořena tabulka "czechia_price_edited"
# Tabulka vytvořena z kódu, který byl pod názvem: přiřazení definic ke kódům do tabulky czechia_price - zjednodušená tabulka

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


# výpočet cenové dostupnosti potravin z přepočtené průměrné hrubé mzdy na zaměstnance v Česku celkem za období let 2006 - 2018 (čtvrtletně)

SELECT *
FROM czechia_payroll_edited AS cpae;

SELECT *
FROM czechia_price_edited AS cpre;

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

/*
 * Otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 * Řešení - tabulka A: Průměrné přepočtené hrubé mzdy na zaměstnance v průběhu let v odvětvích většinou rostou, nicméně není tomu tak vždy. 
 * Například v odvětví Těžby a dobývání klesla v roce 2013 mzda oproti roku 2012 o 1 053 Kč/měsíc, (tj. z 32 540 Kč/měsíc na 31 487 Kč/měsíc).
 * K významnému poklesu došlo v odvětví D. Výroba a rozvod elektřiny mezi roky 2012 a 2013 (z 42 657 Kč/měsíc v roce 2012 na 40 762 Kč/měsíc v roce 2013).
 * 
 * V tabulce B jsou uvedeny změny mezd podle čtvrtletí v jednotlivých odvětvích, kde je patrná větší dynamika mezičtvrtletních změn výše mezd
 */


# Tabulka A: přepočtená průměrná hrubá mzda na zaměstnance v Česku podle jednotlivých let - zjednodušená tabulka

SELECT
	cp.payroll_year,
	COALESCE (cp.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name,
	ROUND(AVG(cp.value),0) AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code  = 200
GROUP BY cp.industry_branch_code, cp.payroll_year;


# Tabulka B: přepočtená průměrná hrubá mzda na zaměstnance v Česku podle čtvrtletí jednotlivých let - zjednodušená tabulka

SELECT
	CONCAT(cp.payroll_year, '_', cp.payroll_quarter) AS year_quarter,
	COALESCE (cp.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name,
	cp.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	((LEAD(cp.value, 1) OVER (ORDER BY cp.id) / cp.value) * 100) - 100 AS next_vs_previous_pct
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code  = 200
GROUP BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter;

/*
 * Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 */

# category_code
# 114 201 - mléko polotučné pasterované
# 111 301 - chléb konzumní kmínový



SELECT
	cpre.year_quarter, cpre.date_from, cpre.date_to,
	cpre.category_code, cpre.category_name, cpre.value,
	cpre.region_code, cpre.region_name, cpre.price_value,
	cpre.price_unit, cpae.avg_salary, cpae.unit_name,
	cpae.value_type_name, cpae.calculation_name,
	ROUND ((cpre.value / cpae.avg_salary) *100 , 3) AS food_affordability_percent
FROM czechia_price_edited AS cpre
LEFT JOIN czechia_payroll_edited AS cpae
	ON cpre.year_quarter = cpae.year_quarter
WHERE cpre.category_code = 114201 OR cpre.category_code = 111301 AND cpre.date_to = '2018-11-18 00:00:00.000';