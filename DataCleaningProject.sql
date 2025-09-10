-- Data Cleaning --
USE employment_data;

Select * from jobsurveyindia;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Find for NULL and Blank values
-- 4. Remove Any Columns (irrelevant or blank)

CREATE TABLE job_staging
LIKE jobsurveyindia;

SELECT* FROM job_staging;

INSERT job_staging
SELECT * FROM jobsurveyindia;

SELECT* FROM job_staging;

INSERT INTO job_staging (employee_id,
employmentsector ,
employmentbackground, 
publicdealing, 
degree, 
IdealNumberOfWorkdays, 
IdealYearlyIncome) 
Values 
(9,'Government Sector','Non-Technical', 'Yes', 'No', 4,'900K-1200K'),
(10,'Government Sector','Art', 'Yes', 'No', 5,'900K-1200K'),
(11,'Government Sector','Non-Technical', 'No', 'No', 5,'More Than 1500K'),
(12,'Government Sector','Technical', 'No', 'No', 5,'More Than 1500K');

USE employment_data;

WITH duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY employee_id, employmentsector,employmentbackground, publicdealing, degree, IdealNumberOfWorkdays
, IdealYearlyIncome) AS row_num
FROM job_staging
)
SELECT*
FROM duplicate_cte
WHERE row_num > 1 ;

CREATE TABLE `job_staging2` (
  `employee_id` int DEFAULT NULL,
  `employmentsector` text,
  `employmentbackground` text,
  `publicdealing` text,
  `degree` text,
  `IdealNumberOfWorkdays` int DEFAULT NULL,
  `IdealYearlyIncome` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT*FROM job_staging2; 

INSERT INTO job_staging2
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY employee_id, employmentsector,employmentbackground, publicdealing, degree, IdealNumberOfWorkdays
, IdealYearlyIncome) AS row_num
FROM job_staging;

SELECT*FROM job_staging2
WHERE row_num > 1; 

DELETE FROM job_staging2
WHERE row_num > 1;

-- Standardizing Data --

SELECT DISTINCT(employmentsector)
FROM job_staging2;

SELECT employmentsector, TRIM(employmentsector)
FROM job_staging2;

UPDATE job_staging2
SET employmentsector = TRIM(employmentsector);

SELECT * FROM job_staging2;











