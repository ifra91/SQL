-- Data Cleaning --
USE employment_data;

SELECT * FROM company_employee_details;

CREATE TABLE detail_staging
LIKE company_employee_details;

SELECT * FROM detail_staging;

INSERT detail_staging
SELECT * FROM company_employee_details;

SELECT * FROM detail_staging;

WITH duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY employee_id, company, department, 
`employee_id_[0]`,age, age_when_joined, years_in_the_company, salary
) AS row_num
FROM detail_staging
)
SELECT*
FROM duplicate_cte
WHERE row_num > 1 ;

CREATE TABLE `detail_staging2` (
  `employee_id` int DEFAULT NULL,
  `company` text,
  `department` text,
  `employee_id_[0]` int DEFAULT NULL,
  `age` int DEFAULT NULL,
  `age_when_joined` int DEFAULT NULL,
  `years_in_the_company` int DEFAULT NULL,
  `salary` double DEFAULT NULL,
  `annual_bonus` double DEFAULT NULL,
  `prior_years_experience` int DEFAULT NULL,
  `full_time` double DEFAULT NULL,
  `part_time` double DEFAULT NULL,
  `contractor` double DEFAULT NULL,
  `row_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM detail_staging2;

Insert INTO detail_staging2
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY employee_id, company, department, 
`employee_id_[0]`,age, age_when_joined, years_in_the_company, salary
) AS row_num
FROM detail_staging;

SELECT * FROM detail_staging2
WHERE row_num > 1;

DELETE FROM detail_staging2
WHERE row_num > 1;

-- Standardizing Data --
SELECT DISTINCT(company)
FROM detail_staging2
ORDER BY 1; 

SELECT company, TRIM(company)
FROM detail_staging2
ORDER BY 1; 

UPDATE detail_staging2
SET company = TRIM(company);

SELECT department
FROM detail_staging2
ORDER BY 1;

SELECT * 
FROM detail_staging2
WHERE department LIKE 'search%';

UPDATE detail_staging2
SET department = 'SEO'
WHERE department LIKE 'Search%';

SELECT DISTINCT(department)
FROM detail_staging2
ORDER BY 1;
;

SELECT DISTINCT department, TRIM(TRAILING '.' FROM department)
FROM detail_staging2
ORDER BY 1;

UPDATE detail_staging2
SET department = TRIM(TRAILING '.' FROM department)
WHERE department LIKE 'BigData%';

SELECT DISTINCT department
FROM detail_staging2
ORDER BY 1;

SELECT DISTINCT department, TRIM(TRAILING '/' FROM department)
FROM detail_staging2
ORDER BY 1;

UPDATE detail_staging2
SET department = TRIM(TRAILING '/' FROM department)
WHERE department LIKE 'Sales%';

SELECT DISTINCT department
FROM detail_staging2
ORDER BY 1;

SELECT ROUND(annual_bonus,2) FROM detail_staging2;

UPDATE detail_staging2
SET annual_bonus =  ROUND(annual_bonus,2);

SELECT annual_bonus FROM detail_staging2;

SELECT * FROM detail_staging
WHERE employee_id IS NULL;

SELECT * FROM detail_staging2;






















