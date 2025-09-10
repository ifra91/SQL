CREATE DATABASE `Employee`;
USE `Employee`;

CREATE TABLE employee_demographics (
employee_id INT NOT NULL,
first_name VARCHAR(50),
last_name VARCHAR(50),
age INT,
gender VARCHAR(10),
birth_date DATE,
PRIMARY KEY (employee_id)
);

CREATE TABLE employee_salary (
employee_id INT NOT NULL,
first_name VARCHAR(50),
last_name VARCHAR(50),
occupation VARCHAR(50),
salary INT,
dept_id INT
);

INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender, birth_date)
VALUES
(1, 'April', 'Wyatt', 33, 'Female','1991-05-12'),
(2, 'Jon', 'Doe', 30, 'Female','1994-05-07'),
(3, 'August', 'Perkins', 29, 'Female','1995-07-09'),
(4, 'May', 'Dwyer', 33, 'Male','1991-05-11'),
(5, 'Ann', 'Craig', 44, 'Female','1979-12-05'),
(6, 'Tom', 'Ben', 38, 'Male','1985-12-05'),
(7, 'Mark', 'Perkins', 43, 'Male','1980-12-05');

INSERT INTO employee_salary(employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES
(1, 'Tom', 'Ben', 'City Manager', 60000, 1),
(2, 'August', 'Perkins', 'Office Manager', 50000, 3),
(3, 'Ann', 'Craig', 'City Planner', 70000, 6),
(4, 'May', 'Dwyer', 'State Auditor', 90000, 1),
(5, 'Jon', 'Doe', 'State Auditor', 57000, 1),
(6, 'Jon', 'Doe', 'Enterprneur', 57000, 4),
(7, 'April', 'Wyatt', 'Nurse', 97000, 2);

CREATE TABLE departments (
department_id INT NOT NULL AUTO_INCREMENT,
department_name VARCHAR(50) NOT NULL,
PRIMARY KEY(department_id)
);

INSERT INTO departments(department_name)
VALUES
('Library'),
('Healthcare'),
('Finance'),
('Enterprenur'),
('Public Works'),
('Recreation');



