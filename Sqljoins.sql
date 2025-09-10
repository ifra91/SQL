USE employee;

Select * from employee_demographics Where age > 33;

-- inner join --
 SELECT dem.employee_id, age, occupation
 FROM employee_demographics AS dem
 INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
-- outer joins --
SELECT * 
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;

SELECT sal.first_name, sal.last_name, occupation, age
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, occupation, age
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
SELECT emp1.employee_id AS emp_id,
emp1.first_name AS f_name,
emp1.last_name AS l_name,
emp2.employee_id AS empl_id,
emp2.first_name AS fs_name,
emp2.last_name AS lt_name
FROM employee_salary AS emp1
RIGHT JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id;
    
-- joining multiple tables together --
SELECT * FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN departments AS dep
	ON sal.dept_id = dep.department_id;
    
-- Unions --
SELECT age, gender 
FROM employee_demographics
UNION SELECT first_name, last_name FROM employee_salary;

-- Unions All --
SELECT first_name, last_name, 'Male' AS Label
FROM employee_demographics
WHERE age > 30 AND gender = 'male'
UNION 
SELECT first_name, last_name, 'Female' AS Label
FROM employee_demographics
WHERE age > 30 AND gender = 'female'
UNION 
SELECT first_name, last_name, 'Highly Paid Employee' AS label
FROM employee_salary
WHERE salary > 60000
ORDER BY first_name, last_name;

-- String Functions -- 
SELECT LENGTH('length of string');

SELECT first_name, LENGTH(first_name)
FROM employee_demographics
UNION ALL
SELECT first_name, LENGTH(first_name)
FROM employee_salary
ORDER BY first_name
;

SELECT UPPER('ann');
SELECT LOWER('AUGUST');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

SELECT ('          SKY                ');
SELECT RTRIM('           SKY             ');
SELECT LTRIM('           SKY             ');

SELECT first_name, LEFT(first_name, 4)
FROM employee_demographics;

SELECT first_name,
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(first_name,3,2),
birth_date,
SUBSTRING(birth_date,6,2)
FROM employee_demographics;

SELECT first_name, REPLACE(first_name, 'A', 'z')
FROM employee_demographics;

SELECT LOCATE('i','April');

-- Cross Join
 CREATE TABLE products 
 (
 id INT PRIMARY KEY AUTO_INCREMENT,
 product_name VARCHAR(100),
 price DECIMAL(13,2)
 );
 
 CREATE TABLE stores 
 (
 id INT PRIMARY KEY AUTO_INCREMENT,
 store_name VARCHAR(100)
 );
 
 CREATE TABLE sales 
 (
 product_id INT ,
 store_id INT ,
 quantity DECIMAL(13,2) NOT NULL,
 sales_date DATE NOT NULL,
 PRIMARY KEY (store_id),
 FOREIGN KEY (product_id)
	REFERENCES products (id)
    ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (store_id)
	REFERENCES stores (id)
    ON DELETE CASCADE ON UPDATE CASCADE 
 );
 
 INSERT INTO products(product_name, price)
 VALUES('iPhone', 699),
		( 'iPad', 599),
        ( 'Macbook Pro', 1299);
        
INSERT INTO stores(store_name)
VALUES('North'),
		('South');
        
INSERT INTO sales(store_id , product_id,  quantity, sales_date)
VALUES  (1,1,20,'2025-01-02'),
		(1,2,15,'2025-02-08'),
        (1,3,25,'2025-03-09'),
        (2,1,30,'2025-04-06'),
        (2,2,35,'2025-05-02');
  
-- INNER JOIN
 SELECT store_name,
		product_name,
        SUM(quantity * price) AS revenue
FROM sales
		INNER JOIN
	products ON products.id = sales.product_id
		INNER JOIN
	stores ON stores.id = sales.store_id
    GROUP BY store_name , product_name;
 
-- CROSS JOIN table store and product
 SELECT store_name, product_name
 FROM stores AS a
	CROSS JOIN 
	products AS b;
    
SELECT product_id , quantity , product_name , store_name
FROM products as a 
	CROSS JOIN 
    sales as b 
    CROSS JOIN 
    stores as c;
    
-- query that returns total of sales by store and product
SELECT 
	b.store_name,
    a.product_name,
    IFNULL(c.revenue, 0) AS revenue
FROM 
	products AS a
		CROSS JOIN
	stores AS b
		LEFT JOIN
	(
    SELECT
    stores.id AS store_id,
    products.id AS product_id,
    store_name,
		product_name,
        ROUND(SUM(quantity * price), 0) AS revenue
        FROM 
			sales
		INNER JOIN products ON products.id = sales.product_id
        INNER JOIN stores ON stores.id = sales.store_id
        GROUP BY stores.id, products.id, store_name, product_name ) AS c ON c.store_id = b.id
			AND c.product_id = a.id
		ORDER BY b.store_name;
    
 
 -- CROSS JOIN table departments and employee_demographics
SELECT department_name , first_name
FROM departments as a
	CROSS JOIN 
    employee_demographics as b;
 
 -- inner Join
 SELECT CONCAT(first_name, " " ,last_name) AS employee_name, department_name, occupation, salary
 FROM departments as d
 INNER JOIN employee_salary as e
	ON e.dept_id = d.department_id
GROUP BY e.first_name, e.last_name, d.department_name,e.occupation, e.salary
ORDER BY e.first_name;
    
-- Self Join
SELECT CONCAT(e.first_name , " " ,e.last_name) AS employee_name, s.occupation, s.salary
FROM employee_salary e
LEFT JOIN employee_salary s ON
	e.employee_id = s.employee_id
ORDER BY e.first_name;

-- self join to compare 
SELECT 
	a.first_name,
    a.occupation,
	b.occupation
FROM
	employee_salary a
INNER JOIN employee_salary b 
ON a.first_name = b.first_name
AND a.occupation > b.occupation
ORDER BY a.first_name;

-- LEFT JOIN  on table products, stores and sales
SELECT p.product_name, quantity , sales_date
FROM products p
LEFT JOIN sales s
ON p.id = s.product_id;

SELECT p.product_name, s.store_name , a.quantity
FROM products p
LEFT JOIN sales a ON a.product_id = p.id
LEFT JOIN stores s USING(id);

SELECT s.store_name, a.sales_date, a.quantity
FROM stores s
LEFT JOIN sales a
	ON s.id = a.product_id;
    
-- RIGHT JOIN
SELECT p.product_name, s.quantity
FROM products p
RIGHT JOIN  sales s 
ON p.id = s.product_id;

SELECT s.store_name, p.product_name
FROM stores s
RIGHT JOIN products p ON p.id = p.id
RIGHT JOIN sales
	ON 	sales.product_id = p.id;

SHOW engines;
SELECT engine, support
FROM 
	information_schema.engines
    ORDER BY 
		engine;

UPDATE products p
JOIN sales s ON p.id = s.product_id
SET quantity = quantity+5
WHERE s.quantity*p.price > 699
; 

select * from products;
select * from sales;

ALTER TABLE sales ADD COLUMN revenue int DEFAULT NULL;

UPDATE sales s
JOIN products p ON s.product_id = p.id
SET revenue = p.price*s.quantity;

DELETE products 
FROM sales
LEFT JOIN products ON products.id = sales.product_id
WHERE sales_date IS NULL;

SELECT CONNECTION_ID();

SHOW PROCESSLIST;

-- LOCK and UNLOCK

CREATE TABLE messages(
id INT AUTO_INCREMENT PRIMARY KEY,
message VARCHAR(100) NOT NULL);

SELECT CONNECTION_ID();

INSERT INTO messages(message)
VALUES('Hello');

LOCK TABLE messages READ;

INSERT INTO messages(message)
VALUES('Hi');

SELECT CONNECTION_ID();

INSERT INTO messages(message)
VALUES('BYE');

SHOW PROCESSLIST;

UNLOCK TABLES;

LOCK TABLE messages WRITE;

INSERT INTO messages(message)
VALUES('Good Morning');

INSERT INTO messages(message)
VALUES('Bye Bye');
SHOW PROCESSLIST;
UNLOCK TABLES;

SELECT * FROM messages;

SHOW CHARACTER SET;

SHOW COLLATION LIKE 'utf%';

SELECT @@secure_file_priv;

-- Selectin Random Records from MYSQL
 SELECT * FROM employee_demographics 
 ORDER BY RAND()
 LIMIT 1;





