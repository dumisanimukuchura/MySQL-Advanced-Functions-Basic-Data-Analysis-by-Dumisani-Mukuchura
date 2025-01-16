
# MySQL for Data Analysis Project 3: Advanced Functions

## Contact Details
- Email: dumisanimukuchura@gmail.com
- LinkedIn: https://www.linkedin.com/in/dumisani-maxwell-mukuchura-4859b7170/

## Project Overview
This project focuses on learning and applying advanced SQL functions using the `Parks_and_Recreation` database. These functions include Common Table Expressions (CTEs), Temporary Tables, Stored Procedures, Triggers, and Events. The goal is to perform complex operations, automate tasks, and enforce data integrity while solving practical business questions.

## Objectives
- Understand and implement advanced SQL functions.
- Solve practical data analysis and management challenges using SQL.
- Automate repetitive tasks and enforce data consistency through advanced functionality.

---

## Dataset Description
The project utilizes the fictional `Parks_and_Recreation` database, which includes the following tables:

### 1. `employee_demographics`
| Column       | Type        | Description                          |
|--------------|-------------|--------------------------------------|
| `employee_id`| INT         | Unique ID for each employee          |
| `first_name` | VARCHAR(50) | Employee's first name                |
| `last_name`  | VARCHAR(50) | Employee's last name                 |
| `age`        | INT         | Employee's age                      |
| `gender`     | VARCHAR(10) | Employee's gender                   |
| `birth_date` | DATE        | Employee's date of birth            |

### 2. `employee_salary`
| Column       | Type        | Description                          |
|--------------|-------------|--------------------------------------|
| `employee_id`| INT         | Unique ID linking to demographics    |
| `first_name` | VARCHAR(50) | Employee's first name                |
| `last_name`  | VARCHAR(50) | Employee's last name                 |
| `occupation` | VARCHAR(50) | Job title                            |
| `salary`     | INT         | Annual salary                        |
| `dept_id`    | INT         | Department ID (foreign key)          |

### 3. `parks_departments`
| Column           | Type        | Description                          |
|------------------|-------------|--------------------------------------|
| `department_id`  | INT         | Unique department ID                 |
| `department_name`| VARCHAR(50) | Name of the department               |

---

## Functions Explored and Questions

### 1. **Common Table Expressions (CTE)**
#### **Definition**
- A temporary result set defined using the `WITH` keyword, which can be referenced within a query.

#### **Questions**
1. Create a CTE to calculate the average salary for each department and list departments with an average salary greater than $60,000.
2. Use a recursive CTE to display a hierarchical structure of employees and their managers.
3. Create a CTE to find the top 3 highest-earning employees in the `employee_salary` table.

---

### 2. **Temporary Tables**
#### **Definition**
- Tables created temporarily for intermediate processing and automatically dropped at the end of the session.

#### **Questions**
1. Create a temporary table to store the total number of employees per department and query it to find departments with more than 5 employees.
2. Use a temporary table to store employees earning above the average salary, and query it for their details.
3. Create a temporary table to calculate the total salary per department and identify the department with the highest total salary.

---

### 3. **Stored Procedures**
#### **Definition**
- A set of SQL statements saved and executed as a single callable unit, defined using the `CREATE PROCEDURE` statement.

#### **Questions**
1. Create a stored procedure to calculate and display the total number of employees in the `parks_departments` table.
2. Write a stored procedure to update the salary of employees in a specific department by a given percentage.
3. Create a stored procedure that accepts a department name and returns the average salary of employees in that department.

---

### 4. **Triggers**
#### **Definition**
- A set of SQL statements executed automatically in response to specific events on a table (e.g., `INSERT`, `UPDATE`, or `DELETE`).

#### **Questions**
1. Create a trigger to log any changes made to the `employee_salary` table into an audit table.
2. Write a trigger to ensure no employee can be added with a salary below $20,000.
3. Create a trigger to automatically update the `parks_departments` table when a new department is added to the system.

---

### 5. **Events**
#### **Definition**
- A scheduled SQL task that runs at specified times or intervals, defined using the `CREATE EVENT` statement.

#### **Questions**
1. Create an event to delete employees from the `employee_demographics` table who are older than 65 years, running daily at midnight.\
2. Write an event to archive salary data into a historical table every month.\
3. Create an event to reset the temporary table of employee counts every week.

---

## How to Run the Project
1. **Set Up the Database**:
   - Ensure the `Parks_and_Recreation` database is available and populated with the required tables.
2. **Run Queries**:
   - Use MySQL Workbench or any SQL client to execute the provided queries.
3. **Explore Further**:
   - Modify queries or create new ones to practice additional functions.

---

## Folder Structure

MySQL-Advanced-Functions/ 
├── sql_scripts/ 
│ └── parks_and_recreation_advanced.sql # SQL script for advanced queries 
├── analysis/
│ └── advanced_queries_and_answers.sql # SQL queries and practice answers 
├── README.md # Project documentation

---

## Project Outcome
- Gained hands-on experience with advanced SQL functions.
- Solved practical business questions using CTEs, Temporary Tables, Stored Procedures, Triggers, and Events.
- Enhanced understanding of advanced SQL concepts and automation techniques.

---

## Future Work
- Integrate advanced functions with reporting tools for business dashboards.
- Explore recursive CTEs for hierarchical data analysis.
- Automate additional database maintenance tasks using Events and Stored Procedures.
"""