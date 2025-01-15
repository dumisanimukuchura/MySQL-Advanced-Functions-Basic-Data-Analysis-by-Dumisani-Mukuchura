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
SELECT * FROM employee_salary WHERE salary > @Avg_Salary; 

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

