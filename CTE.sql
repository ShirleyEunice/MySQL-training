-- COMMON TABLE expression or CTE
-- CONSTRUCT COMPLEX queries IN A MORE READABLE MANNER
-- CTE  results only in execution scope 

-- MySQL introduced the common table expression or CTE  feature 
-- since version 8.0 so you should have MySQL 8.0+ in order to practice with the statements  

-- What is a common table expression or CTE
-- A common table expression is a named temporary result set that exists only within the execution scope of a single SQL statement e.g.,SELECT, INSERT, UPDATE, or DELETE.

-- Similar to a derived table, a CTE is not stored as an object and last only during the execution of a query.

-- Unlike a derived table, a CTE can be self-referencing (a recursive CTE) or can be referenced multiple times in the same query. In addition, a CTE provides better readability and performance in comparison with a derived table.


-- MySQL CTE syntax
-- The structure of a CTE includes the name, an optional column list, and a query that defines the CTE. After the CTE is defined, you can use it as a view in a SELECT, INSERT, UPDATE, DELETE, or CREATE VIEW statement.

WITH cte_name (column_list) AS (
    query
) 
SELECT * FROM cte_name;


-- The following example illustrates how to use a CTE for querying data from the customers table
-- only to demonstrate CTE

WITH customers_in_usa AS (
    SELECT 
        customerName, state
    FROM 
        customers
    WHERE 
        country = 'USA'
) SELECT customerName FROM customers_in_usa WHERE state = 'CA' ORDER BY customerName;

-- see the above query the name of the CTE is customers_in_usa, the query that defines the CTE returns two columns customerName and state. Hence, the customers_in_usa CTE returns all customers located in the USA.


--------------------------------------------------------------------------------------------------------------------------------------------
-- After defining the customers_in_usa CTE, we referenced it in the SELECT statement to select only customers located in California.

WITH topsales2003 AS (
    SELECT 
        salesRepEmployeeNumber employeeNumber,
        SUM(quantityOrdered * priceEach) sales
    FROM
        orders
            INNER JOIN
        orderdetails USING (orderNumber)
            INNER JOIN
        customers USING (customerNumber)
    WHERE
        YEAR(shippedDate) = 2003
            AND status = 'Shipped'
    GROUP BY salesRepEmployeeNumber
    ORDER BY sales DESC
    LIMIT 5
)
SELECT 
    employeeNumber, 
    firstName, 
    lastName, 
    sales
FROM
    employees
        JOIN
    topsales2003 USING (employeeNumber);

+----------------+-----------+-----------+-----------+
| employeeNumber | firstName | lastName  | sales     |
+----------------+-----------+-----------+-----------+
|           1165 | Leslie    | Jennings  | 413219.85 |
|           1370 | Gerard    | Hernandez | 295246.44 |
|           1401 | Pamela    | Castillo  | 289982.88 |
|           1621 | Mami      | Nishi     | 267249.40 |
|           1501 | Larry     | Bott      | 261536.95 |
+----------------+-----------+-----------+-----------+




----------------------------------------------------------
-- Advanced MySQL CTE example

WITH salesrep AS (
    SELECT 
        employeeNumber,
        CONCAT(firstName, ' ', lastName) AS salesrepName
    FROM
        employees
    WHERE
        jobTitle = 'Sales Rep'
),
customer_salesrep AS (
    SELECT 
        customerName, salesrepName
    FROM
        customers
            INNER JOIN
        salesrep ON employeeNumber = salesrepEmployeeNumber
)
SELECT 
    *
FROM
    customer_salesrep
ORDER BY customerName;


+------------------------------------+------------------+
| customerName                       | salesrepName     |
+------------------------------------+------------------+
| Alpha Cognac                       | Gerard Hernandez |
| American Souvenirs Inc             | Foon Yue Tseng   |
| Amica Models & Co.                 | Pamela Castillo  |
---------------------------------------------------------

-- from above query, we have two CTEs in the same query. The first CTE ( salesrep) gets the employees whose job titles are the sales representative. The second CTE ( customer_salesrep ) references the first CTE in the INNER JOIN clause to get the sales rep and customers of whom each sales rep is in charge.

-- After having the second CTE, we query data from that CTE using a simple SELECT statement with the ORDER BY clause.


---------------------------------------------------------------------------------------------

-- MySQL recursive CTE and how to use it to traverse hierarchical data.

-- Notice that common table expression or CTE only available in MySQL version 8.0 or later. Therefore, you should have the right version of MySQL installed in order to use the statements in this tutorial.

Introduction to MySQL recursive CTE
-- A recursive common table expression (CTE) is a CTE that has a subquery which refers to the CTE name itself. The following illustrates the syntax of a recursive CTE

WITH RECURSIVE cte_name AS (
    initial_query  -- anchor member
    UNION ALL
    recursive_query -- recursive member that references to the CTE name
)
SELECT * FROM cte_name;

Description:

-- A recursive CTE consists of three main parts:

-- An initial query that forms the base result set of the CTE structure. The initial query part is referred to as an anchor member.
-- A recursive query part is a query that references to the CTE name, therefore, it is called a recursive member. The recursive member is joined with the anchor member by aUNION ALL or UNION DISTINCT operator.
-- A termination condition that ensures the recursion stops when the recursive member returns no row.
-- The execution order of a recursive CTE is as follows:

-- First, separate the members into two: anchor and recursive members.
-- Next, execute the anchor member to form the base result set ( R0) and use this base result set for the next iteration.
-- Then, execute the recursive member with Ri result set as an input and make Ri+1 as an output.
-- After that, repeat the third step until the recursive member returns an empty result set, in other words, the termination condition is met.
-- Finally, combine result sets from R0 to Rn using UNION ALL operator.
-- Recursive member restrictions
-- The recursive member must not contain the following constructs:

-- Aggregate functions e.g., MAX, MIN, SUM, AVG, COUNT, etc.
-- GROUP BY clause
-- ORDER BY clause
-- LIMIT clause
-- DISTINCT
-- Note that the above constraint does not apply to the anchor member. Also, the prohibition on DISTINCT applies only when you use UNION operator. In case you use the UNION DISTINCT operator, the DISTINCT is permitted.

-- In addition, the recursive member can only reference the CTE name once and in its FROM clause, not in any subquery.

WITH RECURSIVE cte_count (n) 
AS (
      SELECT 1
      UNION ALL
      SELECT n + 1 
      FROM cte_count 
      WHERE n < 3
    )
SELECT n 
FROM cte_count;



-----------------------------------------------------------------------------------------------------

-- Using MySQL recursive CTE to traverse the hierarchical data

-- The  employees table has the reportsTo column that references to the employeeNumber column. The reportsTo column stores the ids of managers. The top manager does not report to anyone in the company’s organization structure, therefore, the value in the reportsTo column is NULL.

-- You can apply the recursive CTE to query the whole organization structure in the top-down manner

WITH RECURSIVE employee_paths AS
  ( SELECT employeeNumber,
           reportsTo managerNumber,
           officeCode, 
           1 lvl
   FROM employees
   WHERE reportsTo IS NULL
     UNION ALL
     SELECT e.employeeNumber,
            e.reportsTo,
            e.officeCode,
            lvl+1
     FROM employees e
     INNER JOIN employee_paths ep ON ep.employeeNumber = e.reportsTo )
SELECT employeeNumber,
       managerNumber,
       lvl,
       city
FROM employee_paths ep
INNER JOIN offices o USING (officeCode)
ORDER BY lvl, city;

