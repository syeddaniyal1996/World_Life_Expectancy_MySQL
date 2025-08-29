USE world_life_expectations;

#Country, Year column analysis

SELECT 
    *
FROM
    worldlifeexpectancy;

SELECT 
    Country, Year
FROM
    worldlifeexpectancy;

SELECT 
    country,
    year,
    CONCAT(country, year) AS country_year,
    COUNT(CONCAT(country, year)) AS count_country
FROM
    worldlifeexpectancy
GROUP BY country , year
HAVING COUNT(CONCAT(country, year)) > 1;

Select Row_ID, concat(country, " ", year) AS country_year,
ROW_NUMBER() Over(PARTITION BY concat(country, year)) AS row_num
From worldlifeexpectancy;

Select Row_ID 
From (Select Row_ID, concat(country, year),
ROW_NUMBER() Over(PARTITION BY concat(country, year)) AS row_num
From worldlifeexpectancy) AS row_table
WHERE row_num > 1;

DELETE FROM worldlifeexpectancy
WHERE Row_ID IN(Select Row_ID 
From (Select Row_ID, concat(country, year),
ROW_NUMBER() Over(PARTITION BY concat(country, year)) AS row_num
From worldlifeexpectancy) AS row_table
WHERE row_num > 1);

#status column analysis

SELECT 
    *
FROM
    worldlifeexpectancy;

SELECT 
    status
FROM
    worldlifeexpectancy
WHERE
    status = '';

SELECT DISTINCT
    (status)
FROM
    worldlifeexpectancy;

UPDATE worldlifeexpectancy 
SET 
    status = 'Developing'
WHERE
    status = '';

#country, `life expectancy` analysis

SELECT 
    country, `Life expectancy`
FROM
    worldlifeexpectancy;

SELECT 
    country, MIN(`Life expectancy`) AS Min_LE, MAX(`Life expectancy`) AS Max_LE
FROM
    worldlifeexpectancy
GROUP BY country
ORDER BY country;

UPDATE worldlifeexpectancy 
SET 
    `Life expectancy` = NULL
WHERE
    `Life expectancy` = '';

SELECT 
    country,
    MIN(`Life expectancy`) AS Min_LE,
    MAX(`Life expectancy`) AS Max_LE,
    ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),
            1) AS increase_in_life
FROM
    worldlifeexpectancy
GROUP BY country
HAVING MIN(`Life expectancy`) > 0
    AND MAX(`Life expectancy`) > 0
ORDER BY increase_in_life DESC;

#year, `Life expectancy` analysis

SELECT 
    year, ROUND(AVG(`Life expectancy`), 2) AS Life_expectations
FROM
    worldlifeexpectancy
GROUP BY year
ORDER BY year;

#country, `Life expectancy`, GDP analysis

SELECT 
    country, `Life expectancy`, GDP
FROM
    worldlifeexpectancy;

SELECT 
    country,
    ROUND(AVG(`Life expectancy`), 2) AS Life_expectations,
    ROUND(AVG(GDP), 2) AS GDP
FROM
    worldlifeexpectancy
GROUP BY country
HAVING GDP > 0 AND Life_expectations > 0
ORDER BY GDP DESC;

SELECT 
    SUM(CASE
        WHEN GDP >= 2500 THEN 1
        ELSE 0
    END) High_GDP_count
FROM
    worldlifeexpectancy;
    
SELECT 
    SUM(CASE
        WHEN GDP <= 2500 THEN 1
        ELSE 0
    END) Low_GDP_count
FROM
    worldlifeexpectancy;
    
SELECT 
    SUM(CASE
        WHEN GDP >= 2500 THEN 1
        ELSE 0
    END) High_GDP_count,
    ROUND(AVG(CASE
                WHEN GDP >= 2500 THEN `Life expectancy`
                ELSE NULL
            END),
            5) AS High_GDP_Life_Expectancy,
    SUM(CASE
        WHEN GDP <= 2500 THEN 1
        ELSE 0
    END) Low_GDP_count,
    ROUND(AVG(CASE
                WHEN GDP <= 2500 THEN `Life expectancy`
                ELSE NULL
            END),
            5) AS Low_GDP_Life_Expectancy
FROM
    worldlifeexpectancy;
    
Select status, round(avg(`Life expectancy`), 1)
From worldlifeexpectancy
WHERE status IS NOT NULL
GROUP BY status;

Select status, count(distinct country), round(avg(`Life expectancy`), 1)
From worldlifeexpectancy
WHERE status IS NOT NULL
GROUP BY status;

Select country, year, `Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY country ORDER BY year) AS Rolling_Total
From worldlifeexpectancy;

Select Country, Year, `Adult Mortality`, 
sum(`Adult Mortality`) OVER(PARTITION BY country ORDER BY year) AS Rolling_Total
From worldlifeexpectancy
WHERE country LIKE 'United%';

Select Country, Year, `Adult Mortality`, 
sum(`Adult Mortality`) OVER(PARTITION BY country ORDER BY year) AS Rolling_Total
From worldlifeexpectancy
WHERE country LIKE 'Pakistan%';

#ADDITIONAL QUERIES TASK

SELECT 
    *
FROM
    worldlifeexpectancy;

# How health exprenditures impacts percentage expenditure

SELECT 
    Country, Year, `percentage expenditure`, `Life expectancy`
FROM 
    worldlifeexpectancy
ORDER BY 
    `percentage expenditure` DESC;
    
# relation between health indicators and BMI

SELECT 
    Country, Year, BMI, `Life expectancy`, `Adult Mortality`, `HIV/AIDS`
FROM 
    worldlifeexpectancy;
    
# vaccination coverage for diseases like Polio and Diphtheria

SELECT 
    Country, Year, Polio, Diphtheria
FROM
    worldlifeexpectancy
WHERE
    Polio IS NOT NULL
        AND Diphtheria IS NOT NULL;