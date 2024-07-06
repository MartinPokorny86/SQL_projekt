# 4. projekt: SQL

Veškeré kroky vytváření pohledů dat a tabulek jsou uvedené v souboru
"SQL_projekt.sql", kam jsem průběžně ukládal záznamy změn (commits) pomocí Gitu na GitHub.

## Postup vytváření projektu SQL - popis dílčích kroků

1. Vypsání seznamu zdrojových datových sad potřebných pro vypracování úkolů

2. Přiřazení definic ke kódům tabulky czechia_payroll

3. Vytvoření pohledu na data o mzdách:

    A. Přepočtená průměrná hrubá mzda na zaměstnance v Česku

        - Přepočtená průměrná hrubá mzda na zaměstnance v Česku ve vybraném sektoru (např. E) a roce (slouží jen pro kontrolu dat)
        - Přepočtená průměrná hrubá mzda na zaměstnance v Česku podle čtvrtletí jednotlivých let podrobná tabulka (s kódy)
        - Přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - zjednodušená tabulka (zde vybrány jen hlavní sloupce pro další práci s daty)

    B. Průměrná hrubá mzda na zaměstnance (fyzické osoby) v Česku

        - Průměrná hrubá mzda na zaměstnance (fyzické osoby) v Česku podle kvartálů jednotlivých let - zjednodušená tabulka (zde vybrány jen hlavní sloupce pro lepší přehlednost datových výstupů)
    
    Pro vypracování primární tabulky t_Martin_Pokorny_project_SQL_primary_final a zpracování
    odpovědí na zadané otázky byla použita metoda A - přepočtená průměrná hrubá mzda na zaměstnance v Česku.

4. Přiřazení definic ke kódům do tabulky czechia_price - podrobná a zjednodušená tabulka

5. Vytvoření dvou tabulek do localhostu (pro lepší čitelost kódu v tabulce t_Martin_Pokorny_project_SQL_primary_final)

    A. Vytvořena nová tabulka "czechia_payroll_edited" s aliasem cpae
        - tabulka vytvořena z kódu evidovaného pod názvem "Přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - zjednodušená tabulka"
    
    B. Vytvořena nová tabulka "czechia_price_edited" s aliasem cpre
        - tabulka vytvořena z kódu evidovaného pod názvem "Přiřazení definic ke kódům do tabulky czechia_price - zjednodušená tabulka"

6. Vytvořen pohled na data z nových tabulek "czechia_payroll_edited" a "czechia_price_edited". Po spuštění kódu "Tabulka 1: t_Martin_Pokorny_project_SQL_primary_final" získáme přehled dat o výpočtu cenové dostupnosti potravin z přepočtené průměrné hrubé mzdy na zaměstnance v Česku celkem za období let 2006 - 2018 (čtvrtletně)

7. Vytvořena finální verze pohledu sekundární tabulky. Po spuštění kódu "Tabulka 2: t_Martin_Pokorny_project_SQL_secondary_final" se zobrazí seznam evropských států podle základních ukazatelů (HDP, GINI koeficient, populace) za období let 2006 - 2018

8. Následují odpovědi na pět otázek, které byly součástí zadání. V rámci jednotlivých řešení jsou k dispozici potřebné pohledy na data, díky kterým mohly být otázky zodpovězeny. 

### Na GitHub uloženy dva soubory s požadovanými kódy

A. t_Martin_Pokorny_project_SQL_primary_final (data mezd a cen potravin za Česko)

B. t_Martin_Pokorny_project_SQL_secondary_final (dodatečná data o dalších evropských státech)



    


