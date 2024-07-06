/*
 * Kód "t_Martin_Pokorny_project_SQL_secondary_final"
 * Evropské státy podle základních ukazatelů: HDP, GINI koeficient, populace za období let 2006 - 2018
 */

# zdrojové datové sady

SELECT *
FROM countries AS c;

SELECT *
FROM economies AS e;

# finální verze pohledu "t_Martin_Pokorny_project_SQL_secondary_final":

SELECT
	e.`year`, e.country, c.continent, e.GDP, e.gini, e.population
FROM economies AS e
LEFT JOIN countries AS c
	ON e.country = c.country
WHERE c.continent = 'Europe' AND e.`year` BETWEEN 2006 AND 2018
ORDER BY e.`year` ASC, e.country ASC;