# 4. projekt: SQL

Součástí souboru "SQL_projekt.sql" jsou kódy v rámci níže popsaných kroků č. 1-4.
V kroku 5 byla vytvořena primární tabulka, v kroku 6 sekundární tabulka.
Poté následují odpovědi na jednotlivé otázky. Pro každou odpověď byl vytvořen soubor s označením čísla otázky.

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

5. Na GitHubu vytvořen soubor "t_Martin_Pokorny_project_SQL_primary_final". 

    Pro lepší čitelost kódu tabulky t_Martin_Pokorny_project_SQL_primary_final je potřeba vytvořit dvě tabulky do localhostu:

        A. tabulka "czechia_payroll_edited" s aliasem cpae
        - vytvořena z kódu evidovaného pod názvem "Přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - zjednodušená tabulka"
    
        B. tabulka "czechia_price_edited" s aliasem cpre
        - vytvořena z kódu evidovaného pod názvem "Přiřazení definic ke kódům do tabulky czechia_price - zjednodušená tabulka"
    
    Pomocí kódu "create table" vytvoříme Tabulku 1: "t_Martin_Pokorny_project_SQL_primary_final", na základě které získáme přehled dat o výpočtu cenové dostupnosti potravin z přepočtené průměrné hrubé mzdy na zaměstnance v Česku celkem za období let 2006 - 2018 (čtvrtletně).

6. Na GitHubu vytvořen soubor "t_Martin_Pokorny_project_SQL_secondary_final". Pomocí kódu _create table_ vytvořena Tabulka 2: "t_Martin_Pokorny_project_SQL_secondary_final", pomocí které se zobrazí seznam evropských států podle základních ukazatelů (HDP, GINI koeficient, populace) za období let 2006 - 2018.

Následují odpovědi na pět otázek, které byly součástí zadání. V rámci jednotlivých řešení jsou k dispozici potřebné pohledy na data, díky kterým mohly být otázky zodpovězeny. Ke každé otázce byl vytvořen sql soubor s podkladovými kódy:

*Otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?*

    Řešení - tabulka A: Průměrné přepočtené hrubé mzdy na zaměstnance v průběhu let v odvětvích většinou rostou, nicméně není tomu tak vždy. Například v odvětví Těžby a dobývání klesla v roce 2013 mzda oproti roku 2012 o 1 053 Kč/měsíc, (tj. z 32 540 Kč/měsíc na 31 487 Kč/měsíc).
 
    K významnému poklesu došlo v odvětví D. Výroba a rozvod elektřiny mezi roky 2012 a 2013 (z 42 657 Kč/měsíc v roce 2012 na 40 762 Kč/měsíc v roce 2013).

    V tabulce B jsou uvedeny změny mezd podle čtvrtletí v jednotlivých odvětvích, kde je patrná větší dynamika mezičtvrtletních změn výše mezd.

*Otázka č. 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?*

    Řešení: Sledované období je 16.12.2018 a 16.12.2007. Výsledky kupní síly vychází z přepočtené průměrné hrubé mzdy na zaměstnance v Česku.

    Ačkoliv konzumní chléb mezi roky 2007 a 2018 zdražil o 1,68 Kč/kg (z 23,06 Kč/kg v roce 2007 na 24,74 Kč/kg v roce 2018), mohl si kupující v Česku v roce 2018 zakoupit ze své mzdy téměř o 395 kg více než v roce 2007 (V roce 2018 si kupující mohl zakoupit 1 376,60 kg, v roce 2007 si mohl ze své mzdy zakoupit 981,83 kg).

    Mléko polotučné pasterované ve sledovaném období podražilo o 1,63 Kč. Zatímco v polovině prosince roku 2007 stál litr mléka 17,92 Kč, o jedenáct let později byla cena litru mléka ve stejném období ve výši 19,55 Kč. Kupní síla se 16.12.2018 oproti 16.12.2007 zvýšila o téměř 480 litrů a kupující si tak mohl v roce 2018 zakoupit ze své mzdy 1 742,05 litrů mléka, ve stejném období roku 2007 si kupující mohl zakoupit 1 263,45 litrů mléka.

*Otázka č. 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?*

    Řešení: Nejpomaleji zdražovala v roce 2007 rajská jablka červená kulatá, jelikož oproti roku 2006 zlevnila o 30 % na 40,32 Kč/kg (jejich cena byla v roce 2006 ve výši 57,83 Kč/kg)

*Otázka č. 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?*

    Řešení: Ano, z upravené tabulky z předchozí otázky najdeme některé kategorie potravin, jejichž cena rostla meziročně více jak o 10 % a zároveň byl trend růstu cen vyšší než růst mezd, jejichž výše za sledované období nepřekročila hranici 9 % (viz upravená tabulka B z řešení první otázky).

    Nejvyšší nárůst cen, téměř o 95 %, byl zaznamenán u kategorie potravin "papriky". V roce 2006 byla cena paprik 35,31 Kč/kg, v roce 2007 cena činila 68,79 Kč/kg.

*Otázka č. 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?*

Vliv HDP na změny ve mzdách

    Největší nárůst HDP v Česku byl v období let 2000 až 2020 zaznamenán mezi roky 2006 a 2005, kdy se v roce 2006 zvýšilo HDP oproti předchozímu roku o 6,8 %. Mzdy se v roce 2006 zvýšily o 6,5 % oproti roku 2005.

    V roce 2007 došlo oproti roku 2006 k mírnějšímu nárůstu HDP o 5,6 %. I přes menší nárůst HDP než tomu bylo při porovnání let 2006 a 2005 (o cca 1 %) došlo v roce 2007 oproti roku 2006 k výraznějšímu nárůstu mezd o 7,2 %.

    V roce 2018 se HDP oproti roku 2017 zvýšilo o 3,2 %. A v roce 2018 došlo k výraznému růstu mezd oproti roku 2017 o 8,2 %.

    Závěrem lze říci, že výraznější růst HDP nemá pravidelný vliv na výrazný růst mezd.

Vliv HDP na změny v cenách potravin

    Z finální tabulky, kterou jsem použil ve třetí otázce, je patrné, že nejmenší meziroční růst cen byl zaznamenán u rajských jablek červených kulatých. V roce 2007 došlo ke snížení jejich ceny oproti roku 2006 o 30,3 %. 

    V roce 2018 se HDP oproti roku 2017 zvýšilo o 3,2 %. Změna výše HDP byla v tomto období nižší než mezi lety 2007 a 2006, kdy činila 5,6 %.

    Při porovnání s rokem 2017 cena rajských jablek v roce 2018 klesla o 0,5 %. V roce 2007 bylo největší zdražení zaznamenáno u paprik, konkrétně o 94,81 % oproti roku 2006. Při porovnání s rokem 2017 cena paprik v roce 2018 klesla o 3,1 %

    V roce 2007 byla pšeničná mouka hladká dražší o 22,6 % než tomu bylo v roce 2006. V té době byl nárůst HDP o 5,6 %. Naopak v roce 2018 byla hladká mouka z pšenice o 0,05 % dražší než v roce 2017. Mouka tak byla v roce 2018 cenově dostupnější, byť v té době bylo HDP o 3,2 % větší než v minulém roce.

    Závěrem lze říci, že rajčata byla levnější při vyšším meziročním růstu HDP (porovnání let 2007/2006) a dražší při nižším meziročním růstu HDP (porovnání let 2018/2017). Naopak papriky byly při vyšším meziročním růstu HDP v roce 2007 mnohem dražší než v roce 2018, kdy meziroční změna HDP činila 3,2 %. Pšeničná mouka hladká byla v rámci porovnání let 2007/2006 dražší než při porovnání let 2018/2017. Výše HDP má tedy různý vliv na cenu u jednotlivých kategorií potravin.

### Na GitHub uloženy následující soubory s požadovanými kódy

A. t_Martin_Pokorny_project_SQL_primary_final (data mezd a cen potravin za Česko)

B. t_Martin_Pokorny_project_SQL_secondary_final (dodatečná data o dalších evropských státech)

C. otazka_1.sql (podkladový kód pro odpověď na otázku č. 1)

D. otazka_2.sql (podkladový kód pro odpověď na otázku č. 2)

E. otazka_3.sql (podkladový kód pro odpověď na otázku č. 3)

F. otazka_4.sql (podkladový kód pro odpověď na otázku č. 4)

G. otazka_5.sql (podkladový kód pro odpověď na otázku č. 5)



    


