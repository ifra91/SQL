

SELECT first_name, last_name, birth_date, age, (age+10)*10+10
FROM employee.employee_demographics;

Select distinct first_name, gender from employee_demographics;

select * from employee_salary where first_name= 'Tom';

select * from employee_salary where salary>60000;

select*from employee_demographics where gender = 'female';

-- AND OR NOT -- LOGICAL OPERATORS
SELECT * FROM employee_demographics WHERE (birth_date > 1985-12-05 AND age = 44 ) or age < 33;

-- like statement --
-- % and --
SELECT * FROM employee_demographics
WHERE first_name LIKE 'Aug%';

SELECT * FROM employee_demographics
WHERE first_name LIKE 'T__%';

SELECT * FROM employee_demographics
WHERE birth_date LIKE '1980%';

-- GROUP BY --
-- Aggregate Function --
SELECT gender, AVG(age)
FROM employee_demographics
group by gender;

SELECT occupation, salary
FROM employee_salary
group by occupation, salary;

SELECT gender, AVG(age), MAX(age), COUNT(age)
FROM employee_demographics
group by GENDER;

-- ORDER BY --
SELECT * FROM employee_demographics
ORDER BY first_name desc;

SELECT * FROM employee_demographics
ORDER BY gender,age;

-- order by column number --
SELECT * FROM employee_demographics
ORDER BY 5,4;

-- HAVING vs WHERE --
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 30;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 50000;

-- LIMIT AND ALIASING --
SELECT * FROM employee_demographics 
ORDER BY age DESC
LIMIT 4;

-- Aliasing --
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 30;

SELECT first_name, salary,
(
SELECT avg(salary)
FROM employee_salary
) 
FROM employee_salary
;

SELECT GENDER, avg(`MAX(age)`)
FROM
(Select gender, AVG(age), Min(age), Max(age), Count(age)
FROM employee_demographics
Group by gender 
) AS Agg_table
Group by gender
;

-- Window Functions --

SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender;

SELECT gender, AVG(salary) OVER(partition by gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

SELECT dem.first_name, dem.last_name, gender, salary,
SUM(salary) OVER(partition by gender order by dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(partition by gender order by salary DESC) AS row_num,
RANK() OVER(partition by gender ORDER BY salary DESC) rank_num,
DENSE_RANK() OVER(partition by gender ORDER BY salary DESC) dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;








