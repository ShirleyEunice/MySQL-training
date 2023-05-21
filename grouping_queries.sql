-- GROUP BY  : 
SELECT
    C1,
    C2,
    C3...CN,
    aggregate_function(ci)
FROM
    table
WHERE
    where_condition
GROUP BY
    C1,
    C2,
    C3...Cn -- Flow
    -- FROM -> WHERE -> GROUP BY -> SELECT -> DISTINCT -> ORDER BY -> LIMIT
    --
SELECT
    status
FROM
    orders
GROUP BY
    status;

--
SELECT
    DISTINCT status
FROM
    orders;

---
SELECT
    status,
    COUNT(*)
FROM
    orders
GROUP BY
    status;

--- Get the total amoun tof all order by status, join order table with orderdetails table
-- SUM 
SELECT
    status,
    SUM(quantityOrdered * priceEach) AS amount
FROM
    orders
    INNER JOIN orderdetails USING (orderNumber)
GROUP BY
    status;

-- Return the order numbers and the total amount of each order
SELECT
    orderNumber,
    SUM(quantityOrdered * priceEach) AS total
FROM
    orderdetails
GROUP BY
    orderNumber;

-- get the total sales for each year
SELECT
    YEAR(orderDate) AS year,
    SUM(quantityOrdered * priceEach) AS total
FROM
    orders
    INNER JOIN orderdetails USING (orderNumber)
WHERE
    status = "Shipped"
GROUP BY
    YEAR(orderDate);

-- GROUP BY WITH HAVING CLAUSE 
-- select the total sales of the years after 2003; 
SELECT
    YEAR(orderDate) AS year,
    SUM(quantityOrdered * priceEach) AS total
FROM
    orders
    INNER JOIN orderdetails USING (orderNumber)
WHERE
    status = "Shipped"
GROUP BY
    year
HAVING
    year > 2003;

-- total number of orders per year
SELECT
    year(orderDate) as YEAR,
    COUNT(orderNumber) AS Total
FROM
    orders
GROUP BY
    YEAR;

--status count
SELECT
    status,
    COUNT(*)
FROM
    orders
GROUP BY
    status;

-- HAVING 
-- HAVING clause is used  in teh SELECT statement to specify filter condition for a groups of rows or aggrgation
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT
-- Get order numbers , the number of items sold per order and total sales for each from the orders table
SELECT
    orderNumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceEach * quantityOrdered) AS total
FROM
    orderDetails
GROUP BY
    orderNumber;

-- Find the total sales greater than 1000 
SELECT
    orderNumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceEach * quantityOrdered) AS total
FROM
    orderDetails
GROUP BY
    orderNumber
HAVING
    total > 1000;

-- Find the total sales greater than 1000 and contains more than 600 items 
SELECT
    orderNumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceEach * quantityOrdered) AS total
FROM
    orderDetails
GROUP BY
    orderNumber
HAVING
    total > 1000
    AND itemsCount > 600;

--Find all the orders that already shipped and total amount greater than 1500
SELECT
    a.orderNumber,
    status,
    SUM(priceEach * quantityOrdered) AS total
FROM
    orderDetails a
    INNER JOIN orders b ON b.orderNumber = a.orderNumber
GROUP BY
    orderNumber,
    status
HAVING
    status = "Shipped"
    AND total > 1500;

-- ROLLUP
-- MySQL ROLLUP clause to generate subtotals and grand totals.
/*
 Creates a new table named sales that stores the order values summarized by product lines and years.
 The data comes from the products, orders, and orderDetails tables
 */
--  products, orders, orderdetails
--  create a sales table 
CREATE TABLE sales
SELECT
    productline,
    YEAR(orderDate) orderYear,
    SUM(priceEach * quantityOrdered) AS orderValue
FROM
    orderDetails
    INNER JOIN orders USING(orderNumber)
    INNER JOIN products USING (productCode)
GROUP BY
    productline,
    orderYear;

-- Grouping set is a set of columns which you wanted to group. 
SELECT
    productline,
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY
    productline;

-- this will create empty group
SELECT
    SUM(orderValue) totalOrderValue
FROM
    sales;

-- two or more grouping sets together in one query UNION ALL
SELECT
    productline,
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY
    productline
UNION
ALL
SELECT
    NULL,
    SUM(orderValue) totalOrderValue
FROM
    sales;

-- Fix the above issues with ROLLUP
SELECT
    productline,
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY
    productline WITH ROLLUP;

--
GROUP BY
    C1,
    C2,
    C3 WITH ROLLUP;

C1 > C2 > C3 -- Generates following grouping set
C1 > C2 > C3 C1 > C2 C1
SELECT
    productline,
    orderYear,
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY
    productline,
    orderYear WITH ROLLUP;

--  productline > orderYear 
SELECT
    orderYear,
    productline,
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY
    orderYear,
    productline WITH ROLLUP;

-- orderYear > productline
-- to check whether NULL in the reult set represents the subtoatal or grand totals, we use GROUPING() function
-- return 1 when NULL occurs in super aggregate row other wise it retuns 0

SELECT
    IF(GROUPING(orderYear), 'All Years', orderYear) orderYear,
    IF(GROUPING(productline), 'All Product Line', productline) productline,
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY
    orderYear,
    productline WITH ROLLUP;