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
