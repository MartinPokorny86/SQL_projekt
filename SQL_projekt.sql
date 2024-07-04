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

# přepočtená průměrná hrubá mzda na zaměstnance ve vybraném sektoru a roce - pouze pro kontrolu dat

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

# přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - podrobná tabulka (s kódy)

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
	cpay.payroll_year,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name,
	ROUND(AVG(cpay.value),0) AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name
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
GROUP BY cpay.industry_branch_code, cpay.payroll_year;


# Tabulka B: přepočtená průměrná hrubá mzda na zaměstnance v Česku podle čtvrtletí jednotlivých let - zjednodušená tabulka

SELECT
	CONCAT(cpay.payroll_year, '_', cpay.payroll_quarter) AS year_quarter,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name,
	cpay.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	((LEAD(cpay.value, 1) OVER (ORDER BY cpay.id) / cpay.value) * 100) - 100 AS next_vs_previous_pct
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

/*
 * Otázka č. 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 * 
 * Řešení: Sledované období je 16.12.2018 a 16.12.2007. Výsledky kupní síly vychází z přepočtené průměrné hrubé mzdy na zaměstnance v Česku.
 * 
 * Ačkoliv konzumní chléb mezi roky 2007 a 2018 zdražil o 1,68 Kč/kg (z 23,06 Kč/kg v roce 2007 na 24,74 Kč/kg v roce 2018),
 * mohl si kupující v Česku v roce 2018 zakoupit ze své mzdy téměř o 395 kg více než v roce 2007 (V roce 2018 si kupující mohl zakoupit 1 376,60 kg,
 * v roce 2007 si mohl ze své mzdy zakoupit 981,83 kg).
 * Mléko polotučné pasterované ve sledovaném období podražilo o 1,63 Kč. Zatímco v polovině prosince roku 2007 stál litr mléka 17,92 Kč, o jedenáct let později
 * byla cena litru mléka ve stejném období ve výši 19,55 Kč. Kupní síla se 16.12.2018 oproti 16.12.2007 zvýšila o téměř 480 litrů a kupující si tak mohl v roce 2018 zakoupit
 * ze své mzdy 1 742,05 litrů mléka, ve stejném období roku 2007 si kupující mohl zakoupit 1 263,45 litrů mléka.
 * 
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


/*
 * Otázka č. 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 * 
 * Řešení: 
 */

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
		ELSE '*'
	END AS next_vs_previous_pct
FROM czechia_price AS cp
LEFT JOIN czechia_price_category AS cpc
	ON cp.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cp.region_code = cr.code
GROUP BY cp.category_code, YEAR(cp.date_to)
ORDER BY cp.category_code, cp.date_to ASC;



