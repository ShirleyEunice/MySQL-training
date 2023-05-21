-- CASE 
CASE
    value
    WHEN value1 THEN result1
    WHEN value2 THEN result2....[ELSE else_result]
END -- return the customers and their orders (order count)
SELECT
    c.customerName,
    COUNT(o.customerNumber) AS order_count
FROM
    customers c
    LEFT JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY
    c.customerNumber,
    c.customerName;
-----------------------------------------
WITH cte AS (
    SELECT
        c.customerName,
        COUNT(o.customerNumber) AS order_count
    FROM
        customers c
        LEFT JOIN orders o ON c.customerNumber = o.customerNumber
    GROUP BY
        c.customerNumber,
        c.customerName
)
SELECT
    customerName,
    order_count,
    CASE
        order_count
        WHEN 1 THEN 'One-time Customer'
        WHEN 2 THEN 'Repeated Customer'
        WHEN 3 THEN 'Frequent Customer'
        ELSE 'Loyal Customer'
    END customerType
FROM
    cte
ORDER BY
    customerName;

----------------------
-- CASE  & ORDER BY 
-- Sort the customer by states if the state is no null 
-- or sort the country in case the state is null 
SELECT
    customerName,
    state,
    country
FROM
    customers
ORDER BY
    (
        CASE
            WHEN state IS NULL THEN country
            ELSE state
        END
    )
limit
    5;

-----------------------------
-- SUM to calculate total sales orders by order status
SELECT
    SUM(
        CASE
            WHEN status = 'Shipped' Then 1
            ELSE 0
        END
    ) AS 'Shipped',
    SUM(
        CASE
            WHEN status = 'On Hold' Then 1
            ELSE 0
        END
    ) AS 'On Hold',
    COUNT(*) AS Total 
FROM
    orders;

-- IF 

SELECT IF(1 = 2, 'TRUE', 'FALSE');
SELECT IF(1 = 1, 'TRUE', 'FALSE');

SELECT 
    customerName,
    customerNumber,
    IF(state IS NULL , 'N/A', state) state,
    country
FROM 
    customers;
-- IFNULL 
IFNULL(expr1, expre2);

IFNULL(1,0); 
IFNULL(NULL,'if null function'); 

employee  info 
    mobile
    home_phone
    
SELECT contactName, IFNULL(mobile, home_phone) phone 
FROM emp_contactact_info;
    

-- NULLIF
NULLIF(expr1, expre2);

CASE WHEN expression1 = expression2 
    THEN NULL 
ELSE
    expression1
END; 

-- get all orders created in june 2003
SELECT 
    orderNumber, orderDate, requiredDate shippedDate, status
FROM orders 
WHERE 
    orderDate BETWEEN '2003-06-01' AND '2003-06-30';


--

SELECT 
    SUM(IF(status = 'Shipped', 1, 0)) / SUM(IF(status = 'Cancelled', 1, 0)) 
FROM orders 
WHERE 
    orderDate BETWEEN '2003-06-01' AND '2003-06-30';


SELECT 
    SUM(IF(status = 'Shipped', 1, 0)) / NULLIF(SUM(IF(status = 'Cancelled', 1, 0)) , 0)
FROM orders 
WHERE 
    orderDate BETWEEN '2003-06-01' AND '2003-06-30';

-----------------------------
