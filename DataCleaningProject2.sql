USE project_data;

CREATE TABLE data1_staging
LIKE dataset1;

INSERT data1_staging
SELECT * FROM dataset1;

ALTER TABLE data1_staging
RENAME COLUMN `ActualÂ gross` TO `actual_gross`;

ALTER TABLE data1_staging
RENAME COLUMN Peak TO peak;

UPDATE data1_staging
SET peak = TRIM(peak);

UPDATE data1_staging
SET `rank` = TRIM(`rank`);

SELECT peak, LEFT(peak,1) AS result FROM data1_staging;

UPDATE data1_staging
SET peak = LEFT(peak,1);

SELECT `rank`, peak from data1_staging;

ALTER TABLE data1_staging 
RENAME COLUMN actual_gross TO `actual_gross(in dollars)`;

SELECT `actual_gross(in dollars)`, TRIM(LEADING '$' FROM `actual_gross(in dollars)`) 
AS result from data1_staging;

UPDATE data1_staging
SET `actual_gross(in dollars)`= TRIM(LEADING '$' FROM `actual_gross(in dollars)`) ;

ALTER TABLE data1_staging
RENAME COLUMN `AdjustedÂ gross (in 2022 dollars)` TO `adjusted_gross(in dollars)`;

UPDATE data1_staging
SET `adjusted_gross(in dollars)`= TRIM(LEADING '$' FROM `adjusted_gross(in dollars)`) ;

ALTER TABLE data1_staging
RENAME COLUMN `All Time Peak` TO all_time_peak;
SELECT all_time_peak, LEFT(all_time_peak,2) AS result FROM data1_staging;
UPDATE data1_staging SET all_time_peak = LEFT(all_time_peak,2);
SELECT all_time_peak , TRIM(TRAILING '[' FROM all_time_peak) AS result FROM data1_staging;
UPDATE data1_staging SET all_time_peak = TRIM(TRAILING '[' FROM all_time_peak);

Select `actual_gross(in dollars)`, TRIM(Trailing'[e]' FROM `actual_gross(in dollars)`) AS result FROM data1_staging;
UPDATE data1_staging SET `actual_gross(in dollars)` = TRIM(Trailing'[e]' FROM `actual_gross(in dollars)`);

ALTER TABLE data1_staging RENAME COLUMN Artist TO artist;
UPDATE data1_staging SET artist = "Beyonce" WHERE artist LIKE 'Beyon%';

ALTER TABLE data1_staging RENAME COLUMN `TOUR TITLE` TO tour_title;
SELECT tour_title, TRIM(TRAILING 'â€¡[21][a]' FROM tour_title) AS result FROM data1_staging;
UPDATE data1_staging SET tour_title = TRIM(TRAILING 'â€¡[21][a]' FROM tour_title);
SELECT tour_title, TRIM(TRAILING 'â€¡[4][a]' FROM tour_title) AS result FROM data1_staging;
UPDATE data1_staging SET tour_title = TRIM(TRAILING 'â€¡[4][a]' FROM tour_title);
SELECT tour_title, TRIM(TRAILING ' â€ '  FROM tour_title) AS result FROM data1_staging;
UPDATE data1_staging SET tour_title = TRIM(TRAILING ' â€ ' FROM tour_title);
SELECT tour_title, TRIM(TRAILING '*' FROM tour_title) AS result FROM data1_staging;
UPDATE data1_staging SET tour_title = TRIM(TRAILING '*' FROM tour_title);

ALTER TABLE data1_staging RENAME COLUMN `YEAR(s)` TO years;
SELECT years FROM data1_staging WHERE years  LIKE '%â€%';
SELECT years , REPLACE(years, 'â€“' , ' - ') FROM data1_staging;
UPDATE data1_staging SET years = REPLACE(years, 'â€“' , ' - ');

ALTER TABLE data1_staging RENAME COLUMN `Shows` TO shows;

ALTER TABLE data1_staging RENAME COLUMN `Average gross` TO average_gross;
SELECT average_gross, TRIM(LEADING '$' FROM average_gross) AS result From data1_staging;
UPDATE data1_staging SET average_gross = TRIM(LEADING '$' FROM average_gross);

ALTER TABLE data1_staging DROP `Ref.`;

-- DELETING DUPLICATES --

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY `Rank`, peak, all_time_peak, artist, tour_title, shows, average_gross) AS row_num
FROM data1_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT * FROM data1_staging
WHERE artist = "Pink";

CREATE TABLE `data2_staging` (
  `Rank` int DEFAULT NULL,
  `peak` text DEFAULT NULL,
  `all_time_peak` text DEFAULT NULL,
  `actual_gross(in dollars)` text DEFAULT NULL,
  `adjusted_gross(in dollars)` text DEFAULT NULL,
  `artist` text,
  `tour_title` text,
  `years` text,
  `shows` int DEFAULT NULL,
  `average_gross` text,
  `row_num` INT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO data2_staging
SELECT *,
ROW_NUMBER() OVER(PARTITION BY `Rank`, peak, all_time_peak, artist, tour_title, shows, average_gross) AS row_num
FROM data1_staging;

SELECT * FROM data2_staging
WHERE row_num > 1;

DELETE FROM data2_staging
WHERE row_num > 1;

-- Standardizing Data (finding discrepancies in data and fixing it) --

SELECT DISTINCT(TRIM(artist)) FROM data2_staging;
UPDATE data2_staging SET artist = TRIM(artist);

UPDATE data2_staging SET peak = FLOOR(RAND() * 10) +1 WHERE peak= ''; 
UPDATE data2_staging SET all_time_peak = FLOOR(RAND() * 10) +1 WHERE all_time_peak = ''; 

SELECT * FROM data2_staging WHERE `Rank` = 7;
UPDATE data2_staging SET `Rank` = 8 WHERE shows = 131;

SELECT `Rank`,
ROW_NUMBER() OVER(ORDER BY `Rank`) AS Result FROM data2_staging;

SELECT `Rank`,
ROW_NUMBER() OVER(ORDER BY `Rank`) AS result,
(`Rank` - ROW_NUMBER() OVER(ORDER BY `Rank`)) AS gaps FROM data2_staging;

-- finding missing ID
-- get min and max id from the table
WITH missingID AS 
(
SELECT MIN(`Rank`) as first_id, MAX(`Rank`) as last_id from data2_staging
),
-- generate the sequence of numbers from minimum and miaximum values of rank using recursive CTE
NumberSeries AS
(
select missingID.first_id as N
UNION ALL
SELECT N+1 from NumberSeries WHERE N<=(SELECT last_id from data2_staging)
)
-- Left Join that will give the skipped value
SELECT * FROM data2_staging
LEFT JOIN NumberSeries
	ON data2_staging.`Rank` = NumberSeries.N;




























