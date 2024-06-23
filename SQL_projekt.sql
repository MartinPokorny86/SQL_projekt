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