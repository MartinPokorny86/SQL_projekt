/*
 * Otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
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