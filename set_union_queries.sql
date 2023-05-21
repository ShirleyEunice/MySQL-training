-- UNION and UNION ALL – combine two or more result sets of multiple queries into a single result set.
-- INTERSECT           –  show you a couple of ways to simulate the INTERSECT operator.
-- MINUS               – explain to you the SQL MINUS operator and show you how to simulate it.

/* MySQL UNION operator to combine two or 
more result sets from multiple SELECT statements into a single result set.*/

SELECT column_list
UNION [DISTINCT | ALL]
SELECT column_list
UNION [DISTINCT | ALL]
SELECT column_list
...

-- To combine result set of two or more queries using the UNION operator, these are the basic rules that you must follow:

-- First, the number and the orders of columns that appear in all SELECT statements must be the same.
-- Second, the data types of columns must be the same or compatible.
-- By default, the UNION operator removes duplicate rows even if you don’t specify the DISTINCT operator explicitly.


-- Create 2 tables;
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;

CREATE TABLE t1 (
    id INT PRIMARY KEY
);

CREATE TABLE t2 (
    id INT PRIMARY KEY
);

INSERT INTO t1 VALUES (1),(2),(3);
INSERT INTO t2 VALUES (2),(3),(4);


-- combine result sets returned from t1 and t2 tables with UNION 
-- combine result sets returned from t1 and t2 tables with UNION ALL

-- use customers and employees

-- combine the first name and last name of employees and customers into a single result set
+-----------+-----------+
| firstName | lastName  |
+-----------+-----------+
| Diane     | Murphy    |
| Mary      | Patterson |
| Jeff      | Firrelli  |
| William   | Patterson |
| Gerard    | Bondur    |
| Anthony   | Bow       |
-------------------------

-- combine the first name and last name of employees and customers into a single result set as a full name single column 
+-------------------+
| fullname          |
+-------------------+
| Diane Murphy      |
| Mary Patterson    |
| Jeff Firrelli     |
| William Patterson |
| Gerard Bondur     |
| Anthony Bow       |
| Leslie Jennings   |
| Leslie Thompson   |
| Julie Firrelli    |
| Steve Patterson   |
+-------------------+

-- sort the result set of a union by fullname
+--------------------+
| fullname           |
+--------------------+
| Adrian Huxley      |
| Akiko Shimamura    |
| Alejandra  Camino  |
| Alexander  Feuer   |
| Alexander  Semenov |
| Allen Nelson       |
| Andy Fixter        |
| Ann  Brown         |
+--------------------+ 

-- differentiate between employees and customers, you can add a column

SELECT
    CONCAT(firstName, ' ', lastName) fullname,
    'Employee' as contactType
FROM
    employees 
UNION 
SELECT 
    CONCAT(contactFirstName, ' ', contactLastName),
    'Customer' AS contactType
FROM 
    customers
ORDER BY 
    fullname LIMIT 10;

+--------------------------+-------------+
| fullname                 | contactType |
+--------------------------+-------------+
| Adrian Huxley            | Customer    |
| Akiko Shimamura          | Customer    |
| Alejandra  Camino        | Customer    |
| Alexander  Feuer         | Customer    |
| Alexander  Semenov       | Customer    |
| Allen Nelson             | Customer    |
| Andy Fixter              | Employee    |
------------------------------------------

--------------------------

-- MySQL also provides you with an alternative option to sort a result set based on column position using ORDER BY clause 

SELECT 
    CONCAT(firstName,' ',lastName) fullname
FROM
    employees 
UNION SELECT 
    CONCAT(contactFirstName,' ',contactLastName)
FROM
    customers
ORDER BY 1;

----------------------------------------------------------------------------------------------------------

-- Introduction to SQL MINUS operator
-- MINUS operator and how to simulate MINUS in MySQL using join.

-- Note that MySQL does not support the MINUS operator. 
-- This example shows you to how to emulate the MINUS operator in MySQL using join clauses.


-- The MINUS operator is one of three set operators in the SQL standard that includes UNION, INTERSECT, and MINUS.

-- The MINUS compares the results of two queries and returns distinct rows from the result set of the first query that does not appear in the result set of the second query.

-- The following illustrates the syntax of the MINUS operator:

SELECT select_list1 
FROM table_name1
MINUS 
SELECT select_list2 
FROM table_name2;


-- The basic rules for a query that uses MINUS operator are the following:

-- The number and order of columns in both select_list1 and select_list2 must be the same.
-- The data types of the corresponding columns in both queries must be compatible.
-- Suppose that we have two tables t1 and t2 with the following structure and data:

CREATE TABLE t1 (
    id INT PRIMARY KEY
);

CREATE TABLE t2 (
    id INT PRIMARY KEY
);

INSERT INTO t1 VALUES (1),(2),(3);
INSERT INTO t2 VALUES (2),(3),(4);

-- The following query returns distinct values from the query of the t1 table that is not found in the result of the query of the t2 table.
SELECT id FROM t1
MINUS
SELECT id FROM t2; 

-------

-- MySQL MINUS operator emulation
-- Unfortunately, MySQL does not support MINUS operator. However, you can use join to emulate it.

-- To emulate the MINUS of two queries, you use the following syntax:

SELECT 
    select_list
FROM 
    table1
LEFT JOIN table2 
    ON join_predicate
WHERE 
    table2.column_name IS NULL; 

-- For example, the following query uses the LEFT JOIN clause to return the same result as the MINUS operator:

SELECT 
    id
FROM
    t1
LEFT JOIN
    t2 USING (id)
WHERE
    t2.id IS NULL;

-------------------------------------------------------------------------------------------------------------------------

-- Introduction to the INTERSECT operator
-- The INTERSECT operator is a set operator that returns only distinct rows of two queries or more queries.

-- Note that MySQL does not support the INTERSECT operator. This tutorial introduces you to how to emulate the INTERSECT operator in MySQL using join clauses.


-- The following illustrates the syntax of the INTERSECT operator.

(SELECT column_list 
FROM table_1)
INTERSECT
(SELECT column_list
FROM table_2);

-- The INTERSECT operator compares the result sets of two queries and returns the distinct rows that are output by both queries.

-- To use the INTERSECT operator for two queries, you follow these rules:

-- The order and the number of columns in the select list of the queries must be the same.
-- The data types of the corresponding columns must be compatible.

-- Emulating INTERSECT in MySQL
-- Unfortunately, MySQL does not support the INTERSECT operator. However, you can emulate the INTERSECT operator.

-- Setting up sample tables
-- The following statements create tables t1 and t2, and then insert data into both tables.
CREATE TABLE t1 (
    id INT PRIMARY KEY
);

CREATE TABLE t2 LIKE t1;

INSERT INTO t1(id) VALUES(1),(2),(3);

INSERT INTO t2(id) VALUES(2),(3),(4);


-- Emulate INTERSECT using DISTINCT and INNER JOIN clause
-- The following statement uses DISTINCT operator and INNER JOIN clause to return the distinct rows in both tables:

SELECT DISTINCT 
   id 
FROM t1
   INNER JOIN t2 USING(id);


-- Emulate INTERSECT using IN and subquery
-- The following statement uses the IN operator and a subquery to return the intersection of the two result sets.

SELECT DISTINCT id
FROM t1
WHERE id IN (SELECT id FROM t2);