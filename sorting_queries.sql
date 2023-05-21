-- ORDER BY CLAUSE 
SELECT 
   select_list
FROM 
   table_name
ORDER BY 
   column1 [ASC|DESC], 
   column2 [ASC|DESC],
   ...;

-- When executing the SELECT statement with an ORDER BY clause, MySQL always evaluates the ORDER BY clause after the FROM and SELECT clauses:
    
    FROM -> SELECT -> ORDER BY
-- use the customers table 

-- sort the customers by their last name in asc order
SELECT
    contactLastname,
    contactFirstname
FROM
    customers
ORDER BY
    contactLastname;

-- sort the customers by their last name in DESC order
SELECT
    contactLastname,
    contactFirstname
FROM
    customers
ORDER BY
    contactLastname DESC;

-- Sort the customers last name by DESC order and first name in asc order
SELECT
    contactLastname,
    contactFirstname
FROM
    customers
ORDER BY
    contactLastname DESC,
    contactFirstname ASC;

-- select the order line items from the orderdetails table. It calculates the subtotal for each line item and sorts the result set based on the subtotal.
SELECT
    orderNumber,
    orderlinenumber,
    quantityOrdered * priceEach
FROM
    orderdetails
ORDER by
    quantityOrdered * priceEach DESC;

-- To make the query more readable, you can assign the expression in the 
-- SELECT clause a column alias and use that column alias in the ORDER BY clause

SELECT
    orderNumber,
    orderlinenumber,
    quantityOrdered * priceEach AS subtotal
FROM
    orderdetails
ORDER by
    subtotal DESC;

--------
-- Using MySQL ORDER BY clause to sort data using a custom list
-- FIELD FUNCTION Syntax
    FIELD(str, str1, str2, ...)

/* The FIELD() function returns the position of the str in the str1, str2, … list. 
If the str is not in the list, the FIELD() function returns 0. For example, 
the following query returns 1 because the position of the string ‘A’ is the first 
position on the list 'A', 'B', and '
*/
SELECT
    FIELD('A', 'B', 'C');

+--------------------------+
| FIELD('A', 'A', 'B','C') |
+--------------------------+
|                        1 |
+--------------------------+

-- If we  want to sort the sales orders based on their statuses in the following order:

-- In Process
-- On Hold
-- Canceled
-- Resolved
-- Disputed
-- Shipped
/*
To do this, you can use the FIELD() function to map each order status to a number and sort the result by the result of the FIELD() function
*/
-- sort order based on their status
SELECT
    orderNumber,
    status
FROM
    orders
ORDER BY
    FIELD(
        status,
        "In Process",
        "On Hold",
        "Cancelled",
        "Resolved",
        "Disputed",
        "Shipped"
    );

-------
-- MySQL ORDER BY and NULL

SELECT
    firstName, lastName, reportsTo
FROM
    employees
ORDER BY reportsTo;

-- if you use the ORDER BY with the DESC option, NULLs will appear last in the result set.
SELECT 
    firstName, lastName, reportsTo
FROM
    employees
ORDER BY reportsTo DESC;