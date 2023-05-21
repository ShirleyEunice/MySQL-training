-- 
SELECT
    select_list
FROM
    table_name;

-- When executing the SELECT statement, MySQL evaluates the FROM clause before the SELECT clause:
FROM
    ->
SELECT
-- use the employees table

-- select single column
SELECT
    lastName
FROM
    employees;

-- select multiple columns
SELECT
    lastName,
    firstName,
    jobTitle
FROM
    employees;

-- select all columns

SELECT employeeNumber,
       lastName,
       firstName,
       extension,
       email,
       officeCode,
       reportsTo,
       jobTitle
FROM   employees; 

-- select all columns with asterisk (*) which is the shorthand for all columns
SELECT
    *
FROM
    employees;

-- MySQL doesn’t require the FROM clause
SELECT
    1 + 1;

--  return the current date and time of the MySQL server
SELECT
    NOW();

-- If a function has parameters, you need to pass arguments into it. For example, concatenate strings into one string, you can use the CONCAT() function:
SELECT
    CONCAT('John', ' ', 'Doe');

-- column alias
SELECT
    expression AS column_alias;

SELECT
    CONCAT('John', ' ', 'Doe') AS name;

SELECT
    CONCAT('Jane', ' ', 'Doe') AS 'Full name';