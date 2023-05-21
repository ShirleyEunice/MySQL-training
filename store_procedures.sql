-- Let's Learn how to develop stored programs including stored procedures and stored functions in MySQL.
Stored procedure Fundamentals 
- Introduction to Stored Procedures in MySQL 
- Changing the default delimiter 
- Creating new stored procedures 
- Removing stored procedures 
- Variables 
- Parameters 
- Altering stored procedure 
- Listing stored procedures 
Stored procedures with Conditional Statements 
Stored procedures with Loops 
Stored procedures with Error Handling 
Stored procedures with Cursors S
tored procedures with Stored Functions 

--------------------------------------------------------------
/*
 What is Store Procedure?
 
 A stored procedure is a prepared SQL code that you can save, 
 so the code can be reused over and over again. So if you have an 
 SQL query that you write over and over again, save it as a stored procedure, 
 and then just call it to execute it. 
 
 What is the execution process of Store procedure?
 
 funciton myfunction(){}
 
 myfunction()
 
 The first time you invoke a stored procedure, MySQL follows these steps:
 - MySQL looks up for the name in the database catalog
 - Compiles the stored procedure’s code
 - Place it in a memory area known as a cache
 - Execute the stored procedure
 
 If you invoke the same stored procedure in the same session again, 
 MySQL just executes the stored procedure from the cache without having to recompile it.
 
 A stored procedure can have parameters so you can pass values to it 
 and get the result back. For example, you can have a stored procedure that 
 returns customers by country and city. In this case, the country and city 
 are parameters of the stored procedure.
 
 A stored procedure may contain control flow statements 
 such as IF, CASE, and LOOP that allow you to implement the code in the procedural way.
 
 A stored procedure can call other stored procedures or 
 stored functions, which allows you to modulize your code.
 
 ---------------------------------------------
 ***MySQL stored procedures advantages
 The following are the advantages of stored procedures.
 
 - Reduce network traffic
 Stored procedures help reduce the network traffic between applications and MySQL Server. Because instead of sending multiple lengthy SQL statements, applications have to send only the name and parameters of stored procedures.
 
 - Centralize business logic in the database
 You can use the stored procedures to implement business logic that is reusable by multiple applications. The stored procedures help reduce the efforts of duplicating the same logic in many applications and make your database more consistent.
 
 - Make database more secure
 The database administrator can grant appropriate privileges to applications that only access specific stored procedures without giving any privileges on the underlying tables.
 ---------------------------------------------
 ***MySQL stored procedures disadvantages
 Besides those advantages, stored procedures also have disadvantages:
 
 - Resource usages
 If you use many stored procedures, the memory usage of every connection will increase substantially.
 
 Besides, overusing a large number of logical operations in the stored procedures will increase the CPU usage because the MySQL is not well-designed for logical operations.
 
 - Troubleshooting
 It’s difficult to debug stored procedures. Unfortunately, MySQL does not provide any facilities to debug stored procedures like other enterprise database products such as Oracle and SQL Server.
 
 - Maintenances
 Developing and maintaining stored procedures often requires a specialized skill set that not all application developers possess. This may lead to problems in both application development and maintenance.
 
 In this tutorial, you have learned about the MySQL stored procedures, their advantages, and disadvantages. Let’s move on to learn how to create a new stored procedure in MySQL.
 
 */
--------------------------------------------------------------
-- Return all rows in the table customers
SELECT
    customerName,
    city,
    state,
    postalCode,
    country
FROM
    customers
ORDER BY
    customerName;

-- +-------------------------+--------------+-------+------------+-----------+
-- | customerName            | city         | state | postalCode | country   |
-- +-------------------------+--------------+-------+------------+-----------+
-- | Alpha Cognac            | Toulouse     | NULL  | 31000      | France    |
-- | American Souvenirs Inc  | New Haven    | CT    | 97823      | USA       |
-- | Amica Models & Co.      | Torino       | NULL  | 10100      | Italy     |
-- | ANG Resellers           | Madrid       | NULL  | 28001      | Spain     |
-- | Anna's Decorations, Ltd | North Sydney | NSW   | 2060       | Australia |
-- +-------------------------+--------------+-------+------------+-----------+
-- 5 rows in set (0.00 sec)
-- Create a Stored Procedure for the above query 
DELIMITER $$
CREATE PROCEDURE GetCustomers() 
BEGIN
    SELECT
        customerName,
        city,
        state,
        postalCode,
        country
    FROM
        customers
    ORDER BY
        customerName;
END $$
DELIMITER;

-----------------
-- Change the default delimiter

DELIMITER delimiter_caracter

DELIMITER //

ex:- 
SELECT * FROM customers //

RESET DELIMITER

DELIMITER ;

-----------------------

CREATE PROCEDURE TO GET ALL PRODUCTS 

DELIMITER $$
CREATE Procedure getAllProducts()
BEGIN
    SELECT * FROM products;
END $$ 
DELIMITER ;

-----------------------

CREATE PROCEDURE procedure_name(parameters_list)
BEGIN
    statements;
END //

CALL stored_procedure_name(arguments_list)


--------------

DELIMITER $$
USE `wileyClassic` $$
CREATE PROCEDURE `GetAllCustomers` ()
BEGIN
    SELECT * FROM customers;
END $$
--------------------------

-- Drop procedure

DROP procedure IF EXISTS `getAllProducts`;

-- List Procedure
SHOW procedure status;

---------------------------

-- Create procedure using parameters

[IN | OUT | INOUT procedure_name data_type(length) ]

DELIMITER $$
CREATE PROCEDURE GetOfficesByCountry(
    IN customerName VARCHAR(255)
)
BEGIN
    SELECT * FROM offices WHERE country = customerName;
END $$
DELIMITER;

---------------
Create procedure to return number of orders by order status;
    input orderstatus VARCHAR
    out total INT 


DELIMITER $$
CREATE PROCEDURE GetOrderCountByStatus(
    IN orderStatus VARCHAR(25),
    OUT total INT
)
BEGIN
    SELECT COUNT(orderNumber)
    INTO total 
    FROM orders 
    WHERE status = orderStatus;
END $$
DELIMITER ;

CALL GetOrderCountByStatus('in process', @total);

SELECT @total as total_in_process;
----------------

DELIMITER $$
CREATE PROCEDURE SetCounter(
    INOUT counter INT, 
    IN inc INT 
)
BEGIN
    SET counter = counter + inc;
END $$
DELIMITER ;

SET @counter = 1;
CALL SetCounter(@counter, 1); --2
CALL SetCounter(@counter, 1); --3
CALL SetCounter(@counter, 7); --10
SELECT @counter;  -- 10

-----------------
-- Using Variables
DECLARE variable_name data_type(size) [DEFAULT default_value]:

DECLARE totalSales DEC(10,2) DEFAULT 0.0;

DECLARE a, b INT DEFAULT 0;

-- Assign values to the Variables


SET variable_name = value;

DECLARE total INT DEFAULT 0;

SET total = 10;


DELIMITER $$
CREATE PROCEDURE  GetTotalOrder()
BEGIN
        DECLARE totalOrder INT DEFAULT 0;

    SELECT COUNT(*)
    INTO totalOrder
    FROM orders;

    SELECT totalOrder;
END $$
DELIMITER ;

CALL GetTotalOrder();
-----------------------------------------

-- List procedure

SHOW PROCEDURE STATUS;

SHOW PROCEDURE STATUS WHERE db='wileyClassic';

SHOW PROCEDURE STATUS LIKE='%order%';


-- list the procedures using data dictionary
SELECT 
    routine_name
FROM 
    information_schema.routines 
WHERE
    routine_type = 'PROCEDURE'
    AND 
    routine_schema = 'wileyClassic';

----------------------
-- Stored procedures with Error Handling 

DECLARE action HANDLER FOR condition_value statement;

CONTINUE OR EXIT ?


DECLARE action HANDLER FOR condition_value statement;
----------

CREATE TABLE SupplierProducts(
    supplierId INT, 
    productId INT,
    PRIMARY KEY (supplierId, productId)
)

DELIMITER $$
CREATE PROCEDURE InsertSupplierProduct(
    IN inSupplierId INT,
    IN inProductId INT
)
BEGIN
    -- exit if the duplicate key occures
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT CONCAT('Duplicate key (', inSupplierId, ',',inProductId,') Occured') AS message;
    END; 

    -- insert new row into the supplierProducts
    INSERT INTO SupplierProducts(supplierId, productId) VALUES(inSupplierId, inProductId);

    -- return the product supplied by the supplier id
    SELECT COUNT(*)
    FROM SupplierProducts
    WHERE supplierId = inSupplierId;

END $$
DELIMITER ;

--------------------------------------------------

-- An 'SQLSTATE' may map to many MySQL error codes
-- 'SQLEXCEPTION' OR 'SQLWARNING' is the shorthand for a class of 'SQLSTATES' values , so that it is the most generic

DELIMITER $$
CREATE PROCEDURE InsertSupplierProduct(
    IN inSupplierId INT,
    IN inProductId INT
)
BEGIN
    -- exit if the duplicate key occures
    DECLARE EXIT HANDLER FOR 1062 SELECT 'Duplicate keys error enountered' Message;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'SQLException enountered' Message;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000' SELECT 'SQLSTATE 23000' ErrorCode;

    -- insert new row into the supplierProducts
    INSERT INTO SupplierProducts(supplierId, productId) VALUES(inSupplierId, inProductId);

    -- return the product supplied by the supplier id
    SELECT COUNT(*)
    FROM SupplierProducts
    WHERE supplierId = inSupplierId;

END $$
DELIMITER ;



-------------------------
DELIMITER $$
CREATE PROCEDURE 
BEGIN

END $$
DELIMITER ;

------------------------------

-- working with function

-- Syntax 
DELIMITER $$

CREATE FUNCTION function_name(
    parameter 1,
    parameter 2 ...
)

RETURN data_type 
BEGIN
    -- statements ...
END $$
DELIMITER ;

-- CREATE a FUNCTION that returns the customer level based on credit

DELIMITER $$

CREATE FUNCTION CustomerLevel(
    credit DECIMAL(10,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE customerLevel VARCHAR(20);

    IF credit > 50000 THEN
            SET customerLevel = 'PLATINUM';
    ELSEIF (credit <= 50000 AND credit <= 10000) THEN
            SET customerLevel = 'GOLD';
    ELSEIF credit < 10000 THEN
            SET customerLevel = 'SILVER';
    END IF;

    RETURN (customerLevel);
        
END $$
DELIMITER ;
----------------------------------
-- List functions 
SHOW FUNCTION STATUS WHERE db='wileyClassic';

---------------------------
-- Use the functions
SELECT 
    customerName,
    CustomerLevel(creditLimit)
FROM    
    customers 
ORDER BY 
    customerName;