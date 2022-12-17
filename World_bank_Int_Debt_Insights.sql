-- CREATING DATABASE AND TABLE

DROP DATABASE IF EXISTS world_bank_int_debt;

CREATE DATABASE world_bank_int_debt;

USE world_bank_int_debt;

CREATE TABLE international_debt(
	country_name varchar(250),
	country_code char(10),
	indicator_name varchar(250),
	indicator_code varchar(250),
	debt bigint 
);

LOAD DATA INFILE 'international_debt.csv'
INTO TABLE international_debt 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM international_debt;

-- ANALYSIS

-- 1. Number of distinct countries

SELECT 
    COUNT(DISTINCT country_name) AS total_distinct_countries
FROM international_debt;

-- There are 124 Distinct countries in the dataset.

-- 2. Distinct indicators

SELECT 
    DISTINCT indicator_code AS distinct_debt_indicators,
    indicator_name AS distinct_debt_desc
FROM international_debt
ORDER BY distinct_debt_indicators;

-- 3. Total amount of debt (in millions, USD) owed by all of the countries in the dataset

SELECT 
    ROUND(SUM(debt)/1000000, 2) AS total_debt
FROM international_debt;

-- 3079734.49 millions USD is owed by all countries.

-- 4. Countries with the highest debt

SELECT 
    country_name, 
    SUM(debt) as total_debt
FROM international_debt
GROUP BY country_name
ORDER BY total_debt DESC
LIMIT 10;

-- China and Brazil owe the highest debt. India is among the top 10 countries that owe the highest debt.

-- 5. Average debt owed by all countries as per each debt indicator

SELECT 
    indicator_code AS debt_indicator,
    indicator_name,
    AVG(debt) AS average_debt
FROM international_debt
GROUP BY debt_indicator, indicator_name
ORDER BY average_debt DESC
LIMIT 10;

/* Countries owe the highest debt for indicator "DT.AMT.DLXF.CD" that refers to
 "Principal repayments on external debt, long-term (AMT, current US$)"  */
 
 -- 6. Country that owes highest amount in "DT.AMT.DLXF.CD" indicator
 
 SELECT 
    country_name, 
    indicator_name
FROM international_debt
WHERE debt = (SELECT 
                 MAX(debt)
             FROM international_debt
             WHERE indicator_code = 'DT.AMT.DLXF.CD');
             
-- China owes the highest amount in "DT.AMT.DLXF.CD" indicator

-- 7. Most common indicator in which companies owe debt

 SELECT 
    indicator_code, 
    COUNT(indicator_code) AS indicator_count
FROM international_debt
GROUP BY indicator_code
ORDER BY indicator_count DESC, indicator_code DESC
LIMIT 20;

-- Maximum amount of debt each country owes in each indicator

SELECT 
    country_name, 
    MAX(debt) AS maximum_debt,
    indicator_name
FROM international_debt
GROUP BY country_name, indicator_name
ORDER BY maximum_debt DESC
LIMIT 10;
 