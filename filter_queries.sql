-- SELECT 
-- WHERE
-- DISTINCT 
-- AND 
-- OR 
-- IN 
-- NOT IN 
-- BETWEEN 
-- LIKE 
-- LIMIT 
-- IS NULL


-- MySQL WHERE clause
SELECT 
    select_list
FROM
    table_name
WHERE
    search_condition;

/*The search_condition is a combination of one or more expressions using the logical operator AND, OR and NOT.

In MySQL, a predicate is a Boolean expression that evaluates to TRUE, FALSE, or UNKNOWN.

The SELECT statement will include any row that satisfies the search_condition in the result set.

Besides the SELECT statement, you can use the WHERE clause in the UPDATE or DELETE statement to specify which rows to update or delete.
*/

-- When executing a SELECT statement with a WHERE clause, MySQL evaluates the WHERE clause after the FROM clause and before the SELECT and ORDER BY clauses:
     FROM -> WHERE -> SELECT -> ORDER BY

-- Use the employees table

-- find all employees whose job titles are Sales Rep
SELECT
    lastName,
    firstName,
    jobTitle
FROM
    employees
WHERE
    jobTitle = "Sales Rep";

-- MySQL WHERE clause with the AND operator
-- Find employees whose job titles are Sales Rep and office codes are 1:

SELECT
    lastName,
    firstName,
    jobTitle,
    officeCode
FROM
    employees
WHERE
    jobTitle = "Sales Rep"
    AND officeCode = 1;

-- MySQL WHERE clause with OR operator
-- Find employees whose job title is Sales Rep or employees who locate the office with office code 1
SELECT
    lastName,
    firstName,
    jobTitle,
    officeCode
FROM
    employees
WHERE
    jobTitle = "Sales Rep"
    AND officeCode = 1
ORDER BY
    officeCode,
    jobTitle;

-- MySQL WHERE clause with the BETWEEN operator:
-- Find employees who locate in offices whose office code is from 1 to 3:
SELECT
    lastName,
    firstName,
    jobTitle,
    officeCode
FROM
    employees
WHERE
    officeCode BETWEEN 1
    AND 3
ORDER BY
    officeCode;


-- MySQL WHERE clause with the LIKE operator 

/*The LIKE operator evaluates to TRUE if a value matches a specified pattern.
To form a pattern, you use the % and _ wildcards. The % wildcard matches any string of zero or more 
characters while the _ wildcard matches any single character.*/

-- Find the employees whose last names end with the string 'son'
SELECT
    lastName,
    firstName
FROM
    employees
WHERE
    lastName LIKE "%son"
ORDER BY
    firstName;

-- MySQL WHERE clause with the IN operator example
-- The IN operator returns TRUE if a value matches any value in a list.
    value IN (value1, value2,...)

/* use the WHERE clause with the IN operator to 
find employees who locate in the office with office code 1 */

SELECT 
    firstName, 
    lastName, 
    officeCode
FROM
    employees
WHERE
    officeCode IN (1 , 2, 3)
ORDER BY 
    officeCode;

-- MySQL WHERE clause with the IS NULL operator
/*
To check if a value is NULL or not, you use the IS NULL operator, not the equal operator (=). 
The IS NULL operator returns TRUE if a value is NULL. */

    value IS NULL   

-- Use the WHERE clause with the IS NULL operator to get the rows with the values in the reportsTo column are NULL:
SELECT
    firstName,
    lastName,
    reportsTo
FROM
    employees
WHERE
    reportsTo IS NULL;

-- IS NOT NULL 
SELECT
    firstName,
    lastName,
    reportsTo
FROM
    employees
WHERE
    reportsTo IS NOT NULL;


-- MySQL WHERE clause with comparison operators

-- Operator	Description
-- =	        Equal to. You can use it with almost any data type.
-- <> or !=	Not equal to
-- <	        Less than. You typically use it with numeric and date/time data types.
-- >	        Greater than.
-- <=	        Less than or equal to
-- >=	        Greater than or equal to

-- Use the not equal to (<>) operator to find all employees who are not the Sales Rep:
SELECT
    firstName,
    lastName,
    jobTitle
FROM
    employees
WHERE
    jobTitle <> 'Sales Rep';

-- find employees whose office code is greater than 5
SELECT
    firstName,
    lastName,
    jobTitle
FROM
    employees
WHERE
    officeCode > 5;

-- return employees with office code less than or equal to 4 (<=4):
SELECT
    firstName,
    lastName,
    jobTitle
FROM
    employees
WHERE
    officeCode <= 4;

-- MySQL DISTINCT clause
/*When querying data from a table, you may get duplicate rows. To remove these duplicate rows, you use the DISTINCT clause in the SELECT statement.*/

-- use the employees
SELECT DISTINCT
    select_list
FROM
    table_name
WHERE 
    search_condition
ORDER BY 
    sort_expression;

/*When executing the SELECT statement with the DISTINCT clause, MySQL evaluates the DISTINCT 
clause after the FROM, WHERE, and SELECT clause and before the ORDER BY clause:*/
    FROM -> WHERE -> SELECT -> DISTINCT -> ORDER BY

SELECT
    DISTINCT lastName
FROM
    employees
ORDER BY
    lastName;

-- DISTINCT NULL
SELECT
    state
FROM
    customers;

--
SELECT
    DISTINCT state
FROM
    customers;

--
SELECT
    DISTINCT state,
    city
FROM
    customers
WHERE
    state IS NOT NULL
ORDER BY
    state,
    city;

-- name, country (USA), state CA, credit limit > 100000 , 
SELECT
    customerName,
    country
FROM
    customers
WHERE
    country = "USA"
    AND state = "CA"
    AND creditLimit > 100000;
--
SELECT
    customerName,
    country
FROM
    customers
WHERE
    country = "USA"
    OR country = "France"
    AND creditLimit > 100000;