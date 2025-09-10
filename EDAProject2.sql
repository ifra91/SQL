USE project_data;

SELECT artist, shows
FROM data2_staging
WHERE shows <= 56;

SELECT 
    MAX(`actual_gross(in dollars)`),
    MAX(`adjusted_gross(in dollars)`),
    MAX(average_gross)
FROM data2_staging;

SELECT * 
FROM data2_staging
WHERE average_gross LIKE '5%';

SELECT *
FROM data2_staging
WHERE shows > 90
ORDER BY average_gross DESC; 

SELECT tour_title, SUM(average_gross) 
FROM data2_staging
WHERE years LIKE '2023%'
GROUP BY tour_title
ORDER BY 2 ASC;

SELECT artist , SUM(shows)
FROM data2_staging
WHERE peak > 2
GROUP BY artist
ORDER BY 1 DESC ;

SELECT years, SUM(peak)
FROM data2_staging
GROUP BY years
ORDER BY 1 DESC;

SELECT YEAR(years) , SUM(peak)
FROM data2_staging
GROUP BY YEAR(years)
ORDER BY 1 DESC;

SELECT artist, AVG(shows)
FROM data2_staging
GROUP BY artist
ORDER BY artist DESC;

-- Rolling Sum
SELECT SUBSTRING(years, 1,4) AS year1, SUM(shows)
FROM data2_staging
WHERE SUBSTRING(years, 1,4) IS NOT NULL 
GROUP BY year1
ORDER BY 1 ASC
;

WITH Rolling_total AS
(
SELECT SUBSTRING(years, 1,4) AS year1, SUM(shows) AS total_shows
FROM data2_staging
WHERE SUBSTRING(years, 1,4) IS NOT NULL 
GROUP BY year1
ORDER BY 1 ASC
)
SELECT year1, total_shows, SUM(total_shows) OVER(ORDER BY year1) AS rolling_total
FROM ROlling_total;

WITH rolling_total2 AS
(
SELECT DISTINCT(artist), years, SUM(shows) AS total
FROM data2_staging
WHERE artist IS NOT NULL
GROUP BY artist, years
ORDER BY artist ASC
)
SELECT 
artist, years, total, SUM(total) OVER(ORDER BY artist) AS rolling2_total
FROM rolling_total2;

WITH Concert_Year (tour_title, years , shows) AS
(
SELECT tour_title, SUBSTRING(years, 1,4) , SUM(shows)
FROM data2_staging
GROUP BY tour_title,  SUBSTRING(years, 1,4)
)
SELECT * , DENSE_RANK() OVER(PARTITION BY SUBSTRING(years, 1,4)  ORDER BY shows  ASC) AS ranking
FROM Concert_Year;

SELECT * 
FROM data2_staging;











