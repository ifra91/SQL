
WITH duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY employee_id, employmentsector,employmentbackground, publicdealing, degree, IdealNumberOfWorkdays
, IdealYearlyIncome) AS row_num
FROM job_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1 ;










