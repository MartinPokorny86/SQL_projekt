/*
 * Otázka č. 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 */

# finální kód:

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

# pracovní kód (pro kontrolu a porovnání dat s následujícím rokem) - výběr kategorie "Rajská jablka červená kulatá"
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
WHERE cp.category_code = 117101
GROUP BY cp.category_code, YEAR(cp.date_to)
ORDER BY cp.category_code, cp.date_to ASC;

# pracovní kód (pro kontrolu a porovnání dat s následujícím rokem) - všechny kategorie
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