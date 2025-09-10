-- CTE Common Expression Table --

WITH CTE_Employee as (
SELECT emp.first_name, emp.last_name, Gender, Salary, 
COUNT(gender) OVER(PARTITION BY Gender) as TotalGender
, AVG(Salary) OVER (PARTITION BY Gender) as AvgSalary
From employee.employee_demographics emp
JOIN employee.employee_salary sal
ON emp.employee_id = sal.employee_id
Where Salary > '20000'
)
Select * From CTE_Employee;

WITH CTE_Example AS
(
SELECT gender, AVG(salary) avg_sal, MAX(salary), MIN(salary), COUNT(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
select AVG(avg_sal) from CTE_Example;


WITH CTE_Example AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics dem
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT * 
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
    ;

-- Temporary Tables --
CREATE TEMPORARY TABLE temp_table
(
first_name varchar(50),
last_name varchar(50),
favourite_movie varchar(50)

);
SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES ('August', 'Dev','Tom and Jerry');

SELECT *
FROM temp_table;

CREATE TEMPORARY TABLE salary_over_50k
(
Select *
From employee_salary
Where salary > 50000
);

SELECT *
FROM salary_over_50k;

CREATE TEMPORARY TABLE age_over_40
(
SELECT * FROM 
employee_demographics
WHERE age > 40
);

SELECT * FROM age_over_40;

-- Stored Procedures --
CREATE PROCEDURE large_salaries()
SELECT * 
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();

DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
    SELECT * 
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT * 
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;

CALL large_salaries2();

DELIMITER $$
CREATE PROCEDURE large_salaries5(employee_id_param INT)
BEGIN
SELECT first_name, last_name, salary
FROM employee_salary
WHERE employee_id = employee_id_param;
END $$
DELIMITER ;

CALL large_salaries5(7)

-- TRIGGERS and EVENTS --


DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
    BEGIN
		INSERT INTO employee_demographics(employee_id, first_name, last_name)
        VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(8, 'Jane' , 'Doe', 'Developer', 100000, NULL);

SELECT * FROM employee_salary;

SELECT * FROM employee_demographics;

-- EVENTS --

SELECT * FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	SELECT * 
	FROM employee_demographics
	WHERE age >= 60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%' ;











