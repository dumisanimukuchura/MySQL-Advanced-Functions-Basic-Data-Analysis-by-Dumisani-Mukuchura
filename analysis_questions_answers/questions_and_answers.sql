-- MySQL for Data Analysis Project 3: Advanced Functions by Dumisani Maxwell Mukuchura

-- 1. Common Table Expressions (CTE)

/*
Definition:
A CTE is a temporary result set that can be referenced within a SQL query.
Defined using the WITH keyword, it makes queries more readable and reusable.

Use Cases:
Simplify complex subqueries by breaking them into readable components.
Enable recursive queries (e.g., hierarchical data like organizational charts).

Questions:
1. Create a CTE to calculate the average salary for each department and list departments with an average salary greater than $60,000.
2. Create a CTE to find the top 3 highest-earning employees in the employee_salary table.
*/

-- Answers to CTE Questions.

-- 1. Create a CTE to calculate the average salary for each department and list departments with an average salary greater than $40,000.

WITH CTE_Avg_Salary_Dept (Department_ID, Average_Salary, Department_Name) AS
(
SELECT dept_id, AVG(salary), pd.department_name
FROM employee_salary sal
JOIN parks_departments pd
	ON sal.dept_id = pd.department_id
GROUP BY dept_id
)
SELECT *
FROM CTE_Avg_Salary_Dept
WHERE Average_Salary > 40000;

-- 2. Create a CTE to find the top 3 highest-earning employees in the employee_salary table.

WITH CTE_Top_3_Earning AS
(
SELECT *
FROM employee_salary
ORDER BY salary DESC
LIMIT 3
)
SELECT *
FROM CTE_Top_3_Earning;

SELECT *
FROM employee_salary;

-- OR We can use Row_Num when LIMIT doesn't work for some CTE nuances depending on SQL Build

WITH CTE_Top_3_Earning AS
(
SELECT *,
	ROW_NUMBER() OVER(ORDER BY salary DESC) AS RowNum
FROM employee_salary
)
SELECT *
FROM CTE_Top_3_Earning
WHERE RowNum <= 3;

-- -------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Temporary Tables

/*
Definition:
Temporary tables are tables created for intermediate processing, which are automatically dropped at the end of the session.
Created using the CREATE TEMPORARY TABLE statement.

Use Cases:
Store intermediate results for complex operations.
Optimize performance by reusing intermediate calculations in multiple steps.

Questions:
1. Create a temporary table to store the total number of employees per department and query it to find departments with more than 1 employee.
2. Use a temporary table to store employees earning above the average salary, and query it for their details.
3. Create a temporary table to calculate the total salary per department and identify the department with the highest total salary.
*/

-- 1. Create a temporary table to store the total number of employees per department and query it to find departments with more than 1 employee.

DROP TEMPORARY TABLE IF EXISTS More_Than_1_Employee; -- DROP TEMP TABLE IF IT EXISTS 

CREATE TEMPORARY TABLE More_Than_1_Employee AS 
SELECT dept_id, pd.department_name, COUNT(*) AS EmployeeCount
FROM employee_salary sal
JOIN parks_departments pd
	ON sal.dept_id = pd.department_id
GROUP BY dept_id
HAVING COUNT(*) > 1;

SELECT *
FROM More_Than_1_Employee;

-- 2. Use a temporary table to store employees earning above the average salary, and query it for their details.

DROP TEMPORARY TABLE IF EXISTS Above_Salary_Average; 

CREATE TEMPORARY TABLE Above_Salary_Average AS 
SELECT sal.*, avg_table.Avg_Salary 
FROM employee_salary sal 
JOIN 
( SELECT AVG(salary) AS Avg_Salary 
  FROM employee_salary
) AS avg_table 
	ON sal.salary > avg_table.Avg_Salary; 
    
-- Query the temporary table for their details 
SELECT * 
FROM  Above_Salary_Average;

-- Alternative Way using CTE and not a SubQuery on Join 

-- Calculate the average salary
SET @Avg_Salary = (SELECT AVG(salary) FROM employee_salary);

-- DROP TEMP TABLE IF IT EXISTS
DROP TEMPORARY TABLE IF EXISTS Above_Salary_Average;

CREATE TEMPORARY TABLE Above_Salary_Average AS 
SELECT * FROM employee_salary 
WHERE salary > @Avg_Salary; 

-- Query the temporary table for their details 
SELECT * 
FROM Above_Salary_Average;

-- 3. Create a temporary table to calculate the total salary per department and identify the department with the highest total salary.

DROP TEMPORARY TABLE IF EXISTS Total_Salary_Per_Department;

CREATE TEMPORARY TABLE Total_Salary_Per_Department AS
SELECT sal.dept_id, pd.department_name, SUM(salary) AS Dept_Salary
FROM employee_salary sal
JOIN parks_departments pd
	ON sal.dept_id = pd.department_id
GROUP BY dept_id
ORDER BY Dept_Salary DESC;

SELECT *
FROM Total_Salary_Per_Department;

-- Parks and Recreation has the highest Department Salary Total.

-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 3. Stored Procedures

/*
Definition:
A stored procedure is a set of SQL statements saved and executed as a single callable unit.
Defined using the CREATE PROCEDURE statement.

Use Cases:
Automate repetitive tasks (e.g., daily reporting).
Encapsulate complex business logic for reuse and consistency.

Questions:
1. Create a stored procedure to calculate and display the total number of employees in the parks_departments table.
2. Write a stored procedure to update the salary of employees in a specific department by a given percentage.
3. Create a stored procedure that accepts a department name and returns the average salary of employees in that department.
*/

-- 1. Create a stored procedure to calculate and display the total number of employees in the parks_departments table.
DROP PROCEDURE IF EXISTS Total_Employees;

DELIMITER $$

CREATE PROCEDURE Total_Employees()
BEGIN
	SELECT COUNT(sal.employee_id) AS Employee_Total
	FROM parks_departments pd
	JOIN employee_salary sal
		ON pd.department_id  = sal.dept_id;
END $$

DELIMITER ;
    
CALL Total_Employees();

-- 2. Write a stored procedure to update the salary of employees in a specific department by a given percentage.

-- Static Method to Create another Updated_Salary column
DROP PROCEDURE IF EXISTS Update_Salary;

DELIMITER $$

CREATE PROCEDURE Update_Salary()
BEGIN
	SELECT *, salary * 1.10 AS Updated_Salary
	FROM employee_salary
	WHERE dept_id = 1;
END $$

DELIMITER ;

CALL Update_Salary();

-- Dynamic Alternative Method to Actually Update
DROP PROCEDURE IF EXISTS Update_Salary;

DELIMITER $$

CREATE PROCEDURE Update_Salary(IN p_dept_id INT, IN p_percentage DECIMAL(5, 2))  -- 5 - precision, 2 scale i.e dp MAX 999.99 MIN -999.99 in this case
BEGIN 
	UPDATE employee_salary 
    SET salary = salary * (1 + p_percentage / 100) 
    WHERE dept_id = p_dept_id; 
END $$ 

DELIMITER ; 

CALL Update_Salary(1, 10);


-- 3. Create a stored procedure that accepts a department name and returns the average salary of employees in that department.

DROP PROCEDURE IF EXISTS Average_Dept_Salary;

DELIMITER $$ 
CREATE PROCEDURE Average_Dept_Salary(IN p_department_name VARCHAR(255)) 
BEGIN 
	SELECT AVG(salary) AS Avg_Salary 
	FROM employee_salary sal 
	JOIN parks_departments pd 
		ON sal.dept_id = pd.department_id 
	WHERE pd.department_name = p_department_name; 
END $$

DELIMITER ;

CALL Average_Dept_Salary('Parks and Recreation');

-- Confirmational Code:

DELIMITER $$
CREATE PROCEDURE Average_Dept_Salary(p_department_id INT)
BEGIN
	SELECT AVG(salary) AS Avg_Salary
	FROM employee_salary sal
	JOIN parks_departments pd
		ON sal.dept_id = pd.department_id
	WHERE pd.department_id = p_department_id;
END $$

DELIMITER ;

CALL Average_Dept_Salary(1);

-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- 4. TRIGGERS

/*
Definition:
A trigger is a set of SQL statements executed automatically in response to specific events on a table (e.g., INSERT, UPDATE, or DELETE).

Use Cases:
Enforce data integrity (e.g., ensure valid data entry).
Track changes to critical data (e.g., log salary updates).

Questions:
1. Create a trigger to log any changes made to the employee_salary table into an audit table.
2. Write a trigger to ensure no employee can be added with a salary below $20,000.
3. Create a trigger to automatically update the parks_departments table when a new department is added to the system.
*/

-- 1. Create a trigger to log any changes made to the employee_salary table into an audit table.

-- Step 1: Create the audit table
CREATE TABLE audit_employee_salary (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_type VARCHAR(10), -- 'INSERT', 'UPDATE', 'DELETE'
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 2: Create the trigger
-- Trigger for INSERT
DELIMITER $$

CREATE TRIGGER log_employee_salary_insert
AFTER INSERT ON employee_salary
FOR EACH ROW
BEGIN
    INSERT INTO audit_employee_salary (employee_id, new_salary, change_type)
    VALUES (NEW.employee_id, NEW.salary, 'INSERT');
END $$

DELIMITER ;

-- Test Case for INSERT 

-- Insert a new employee into the employee_salary table
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (101, 'Dumisani', 'Maxwell', 'Wildlife AI Tracker', 50000, 1);

-- Check the audit table for the new entry
SELECT * 
FROM audit_employee_salary 
WHERE employee_id = 101;

-- Trigger for UPDATE

DELIMITER $$

CREATE TRIGGER log_employee_salary_update
AFTER UPDATE ON employee_salary
FOR EACH ROW
BEGIN
    INSERT INTO audit_employee_salary (employee_id, old_salary, new_salary, change_type)
    VALUES (OLD.employee_id, OLD.salary, NEW.salary, 'UPDATE');
END $$

DELIMITER ;

-- Test Case for Update 

-- Update the salary of an existing employee
UPDATE employee_salary
SET salary = 55000
WHERE employee_id = 101;

-- Check the audit table for the update entry
SELECT * 
FROM audit_employee_salary 
WHERE employee_id = 101;

-- Trigger for DELETE

DELIMITER $$

CREATE TRIGGER log_employee_salary_delete
AFTER DELETE ON employee_salary
FOR EACH ROW
BEGIN
    INSERT INTO audit_employee_salary (employee_id, old_salary, change_type)
    VALUES (OLD.employee_id, OLD.salary, 'DELETE');
END $$

DELIMITER ;

-- Test Case for Delete 

-- Delete the employee from the employee_salary table
DELETE 
FROM employee_salary 
WHERE employee_id = 101;

-- Check the audit table for the delete entry
SELECT * 
FROM audit_employee_salary 
WHERE employee_id = 101;

-- 2. Write a trigger to ensure no employee can be added with a salary below $20,000.

DELIMITER $$

CREATE TRIGGER prevent_low_salary
BEFORE INSERT ON employee_salary
FOR EACH ROW
BEGIN
    IF NEW.salary < 20000 THEN
        SIGNAL SQLSTATE '45000'  -- SINAL: This keyword is used to raise an error in SQL, The SQLSTATE code '45000' is a general error condition. It is commonly used to indicate a user-defined exception.
        SET MESSAGE_TEXT = 'Salary cannot be less than $20,000';  -- SET MESSAGE TEXT: This clause provides a custom error message that is displayed when the error is raised.
    END IF;
END $$

DELIMITER ;

-- Test Case for Employee wih less than $20,000

-- Attempt to insert an employee with a low salary
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (102, 'Ralph', 'Maxwell', 'Domestic Animal Trainer', 15000, 1);

-- Test Case for Employee with above $20000 salary

-- Insert an employee with a valid salary
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (102, 'Ralph', 'Maxwell', 'Domestic Animal Trainer', 25000, 1);

-- Check if the insertion was successful
SELECT * 
FROM employee_salary 
WHERE employee_id = 102;

-- 3. Create a trigger to automatically update the parks_departments table when a new department is added to the system.

-- Create Table departments for Test Case usage
CREATE TABLE IF NOT EXISTS departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255)
);

-- Creating the after_insert_trigger
DELIMITER $$

CREATE TRIGGER after_insert_department
AFTER INSERT ON departments
FOR EACH ROW
BEGIN
    INSERT INTO parks_departments (department_id, department_name)
    VALUES (NEW.department_id, NEW.department_name);
END $$

DELIMITER ;

-- Test Case 
-- Insert a new department
INSERT INTO departments (department_id, department_name)
VALUES (10, 'New Parks Department');

-- Check if the new department is added to parks_departments
SELECT * 
FROM parks_departments 
WHERE department_id = 10;

-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 5. Events

/*
Definition:
An event is a scheduled SQL task that runs at specified times or intervals.
Created using the CREATE EVENT statement.

Use Cases:
Automate periodic tasks (e.g., cleaning old records).
Generate automated reports or backups.

Questions:
1. Create an event to delete employees from the employee_demographics table who are older than 60 years, running daily at midnight.
2. Write an event to archive salary data into a historical table every month.
3. Create an event to reset the temporary table of employee counts every week.
*/


-- 1. Create an event to delete employees from the employee_demographics table who are older than 60 years, running daily at midnight.

DELIMITER $$

CREATE EVENT delete_retirees
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY
DO
BEGIN
    DELETE 
    FROM employee_demographics
    WHERE age >= 60;
END $$

DELIMITER ;

-- 2 Write an event to archive salary data into a historical table every month.

CREATE TABLE IF NOT EXISTS salary_archive (
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT,
  archive_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER $$

CREATE EVENT archive_salary_data
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP + INTERVAL 1 MONTH
DO
BEGIN
    INSERT INTO salary_archive (employee_id, first_name, last_name, occupation, salary, dept_id)
    SELECT employee_id, first_name, last_name, occupation, salary, dept_id
    FROM employee_salary
    WHERE employee_id NOT IN (SELECT employee_id FROM salary_archive);
END $$

DELIMITER ;


-- 3. Create an event to reset the temporary table of employee counts every week.

DROP TEMPORARY TABLE IF EXISTS Total_Employee_Count; -- DROP TEMP TABLE IF IT EXISTS 

CREATE TEMPORARY TABLE Total_Employee_Count AS 
SELECT COUNT(*) AS Employee_Count
FROM employee_salary;

SELECT *
FROM Total_Employee_Count;

DELIMITER $$

CREATE EVENT reset_employee_total_count
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP + INTERVAL 1 WEEK
DO
BEGIN
    TRUNCATE TABLE Total_Employee_Count;  -- Empties the temporary table.
    INSERT INTO Total_Employee_Count (Employee_Count) -- Inserts the current employee count into the temporary table.
    SELECT COUNT(*) AS Employee_Count 
    FROM employee_salary;
END $$

DELIMITER ;

-- TEST CASES WITH TIMES THAT CAN BE WORKED WITH

-- For Question 1:

DELIMITER $$

CREATE EVENT delete_retirees
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
DO
BEGIN
    DELETE 
    FROM employee_demographics
    WHERE age >= 60;
END $$

DELIMITER ;

-- Test Case:
INSERT INTO employee_demographics (employee_id, age)
VALUES (103, 70);

-- Wait for the event to run

SELECT * 
FROM employee_demographics 
WHERE employee_id = 103;

-- Expected Result: No rows should be returned for employee_id = 103

--  For Question 2: Write an event to archive salary data into a historical table every month.

CREATE TABLE IF NOT EXISTS salary_archive (
  employee_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  occupation VARCHAR(50),
  salary INT,
  dept_id INT,
  archive_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$ 

CREATE EVENT archive_salary_data 
ON SCHEDULE EVERY 1 MINUTE STARTS CURRENT_TIMESTAMP + INTERVAL 1 MINUTE 
DO 
BEGIN 
	INSERT INTO salary_archive (employee_id, first_name, last_name, occupation, salary, dept_id) 
	SELECT employee_id, first_name, last_name, occupation, salary, dept_id 
	FROM employee_salary 
	WHERE employee_id NOT IN (SELECT employee_id FROM salary_archive); 
END $$ 

DELIMITER ;

-- Test Case

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (104, 'John', 'Doe', 'Manager', 60000, 1);

-- Wait for the event to run

SELECT * 
FROM salary_archive 
WHERE employee_id = 104;

-- Expected Result: A row should be returned for employee_id = 104.

-- For Question 3: Create an event to reset the temporary table of employee counts every week.

DROP TEMPORARY TABLE IF EXISTS Total_Employee_Count;

CREATE TEMPORARY TABLE Total_Employee_Count AS 
SELECT COUNT(*) AS Employee_Count
FROM employee_salary;

SELECT *
FROM Total_Employee_Count;

-- Event Code 

DELIMITER $$

CREATE EVENT reset_employee_total_count
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
DO
BEGIN
    TRUNCATE TABLE Total_Employee_Count;
    INSERT INTO Total_Employee_Count (Employee_Count)
    SELECT COUNT(*) AS Employee_Count
    FROM employee_salary;
END $$

DELIMITER ;


-- Test Case

SELECT * 
FROM Total_Employee_Count;

-- Note down the current employee count

INSERT INTO employee_salary (employee_id, salary)
VALUES (105, 50000);

-- Wait for the event to run

SELECT * 
FROM Total_Employee_Count;

-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- Additional Notes:

/*
SQL Execution Order
FROM: Specifies the tables from which to retrieve data.
Example: FROM employee_salary

JOIN:Joins tables based on conditions.
Example: JOIN parks_departments ON employee_salary.dept_id = parks_departments.department_id

WHERE: Filters rows before grouping.
Example: WHERE age >= 30

GROUP BY: Groups rows that share a property.
Example: GROUP BY dept_id

HAVING: Filters groups after grouping.
Example: HAVING COUNT(*) > 1

SELECT: Selects columns or expressions.
Example: SELECT dept_id, COUNT(*)

DISTINCT:Removes duplicate rows from the result.
Example: SELECT DISTINCT department_name

ORDER BY: Sorts the result.
Example: ORDER BY salary DESC

LIMIT / OFFSET: Limits the number of returned rows or skips rows.
Example: LIMIT 10 OFFSET 5
*/

SELECT dept_id, COUNT(*) AS EmployeeCount
FROM employee_salary
JOIN parks_departments ON employee_salary.dept_id = parks_departments.department_id
WHERE age >= 30
GROUP BY dept_id
HAVING COUNT(*) > 1
ORDER BY EmployeeCount DESC
LIMIT 5;

-- ------------------------------------------------------------------------------------------------------------------------------------------









