-- MySQL uses indexes to quickly find rows with specific column values. 
    -- Without an index, MySQL must scan the whole table to locate the relevant rows. 
    -- The larger table, the slower it searches.

-- Important features of indexes in MySQL
Creating indexes        – introduces you to the index concept and shows you how to create an index for one or more columns of a table.
Removing indexes        – shows you how to remove an existing index of a table.
Listing table indexes   – provides you with a statement to list all indexes or specific indexes of a table.
Unique indexes          – uses the unique indexes to ensure distinct values stored in a column.
Prefix indexes          – shows you how to use the prefix index to create an index for a character string column.
Invisible indexes       – covers the index visibility and shows you how to make an index visible or invisible.
Descending indexes      –  shows you how to use descending indexes to increase query performance.
Composite indexes       – illustrates the application of composite indexes and shows you when to use them to speed up your queries.
Clustered indexes       – explains the clustered indexes in InnoDB tables.
Index cardinality       – explains the index cardinality and shows you how to view it using the show indexes command.
USE INDEX hint          –  shows you how to use the USE INDEX hint to instruct the query optimizer to use the only list of specified indexes to find rows in a table.
FORCE INDEX hint        – shows you how to use the FORCE INDEX hint to force the query optimizer to use specified indexes to select data from a table.

---------------------------------------------------------------

CREATE TABLE t(
   c1 INT PRIMARY KEY,
   c2 INT NOT NULL,
   c3 INT NOT NULL,
   c4 VARCHAR(10),
   INDEX (c2,c3) 
);

CREATE INDEX index_name ON table_name (column_list)

CREATE INDEX idx_c4 ON t(c4);

-- By defalut MySQL creates the B-Tree index if we don't specify the index type

storage engine      allowed index types 
InnoDB              BTREE
MyISAM              BTREE
MEMORY/HEAP         Hash, BTREE

-----------------------------
SELECT 
    employeeNumber,
    lastName,
    firstName
FROM 
    employees 
WHERE
    jobTitle = 'Sales Rep';


EXPLAIN FORMAT=JSON SELECT 
    employeeNumber,
    lastName,
    firstName
FROM 
    employees 
WHERE
    jobTitle = 'Sales Rep';

CREATE INDEX idx_jobTitle ON employees(jobTitle);

--------------------------------------------

-- MySQL DROP INDEX statement syntax
-- To remove an existing index from a table, you use the DROP INDEX statement as follows:

    DROP INDEX index_name ON table_name
    [algorithm_option | lock_option]

-- In this syntax:

-- First, specify the name of the index which you want to remove after the DROP INDEX keywords.
-- Second, specify the name of the table to which the index belongs.

-- Algorithm
-- The algorithm_option allows you to specify a specific algorithm used for the index removal. The following shows the syntax of the algorithm_option clause:

     ALGORITHM [=] {DEFAULT|INPLACE|COPY}

-- For the index removal, the following algorithms are supported:

-- COPY: The table is copied to the new table row by row, the DROP INDEX is then performed on the copy of the original table. The concurrent data manipulation statements such as INSERT and UPDATE are not permitted.

-- INPLACE: The table is rebuilt in place instead of copied to the new one. MySQL issues an exclusive metadata lock on the table during the preparation and execution phases of the index removal operation. This algorithm allows for concurrent data manipulation statements.
-- Note that the ALGORITHM clause is optional. If you skip it, MySQL uses INPLACE. In case the INPLACE is not supported, MySQL uses COPY.

-- Using DEFAULT has the same effect as omitting the ALGORITHM clause.

Lock
The lock_option controls the level of concurrent reads and writes on the table while the index is being removed.

The following shows the syntax of the lock_option:

    LOCK [=] {DEFAULT|NONE|SHARED|EXCLUSIVE}

-- The following locking modes are supported:

--  - DEFAULT: this allows you to have the maximum level of concurrency for a given algorithm. First, it allows concurrent reads and writes if supported. If not, allow concurrent reads if supported. If not, enforce exclusive access.
--  - NONE: if the NONE is supported, you can have concurrent reads and writes. Otherwise, MySQL issues an error.
--  - SHARED: if the SHARED is supported, you can have concurrent reads, but not writes. MySQL issues an error if the concurrent reads are not supported.
--  - EXCLUSIVE: this enforces exclusive access.

CREATE TABLE leads(
    lead_id INT AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    information_source VARCHAR(255),
    INDEX name(first_name,last_name),
    UNIQUE email(email),
    PRIMARY KEY(lead_id)
);


The following statement removes the name index from the leads table:

    DROP INDEX name ON leads;

The following statement drops the email index from the leads table with a specific algorithm and lock:

    DROP INDEX email ON leads
    ALGORITHM = INPLACE 
    LOCK = DEFAULT;

MySQL DROP PRIMARY KEY index
To drop the primary key whose index name is PRIMARY, you use the following statement:

    DROP INDEX `PRIMARY` ON table_name;

The following statement creates a new table named twith a primary key:

    CREATE TABLE t(
        pk INT PRIMARY KEY,
        c VARCHAR(10)
    );

Code language: SQL (Structured Query Language) (sql)
To drop the primary key index, you use the following statement:

    DROP INDEX `PRIMARY` ON t;

----------------------------------------------------------------------
--- List indexes 

SHOW INDEXES FROM employees;

-- when we don't connect to any database
SHOW INDEXES FROM employees IN database_name;
SHOW INDEXES FROM database_name.table_name;


SHOW INDEXES IN employees FROM database_name
OR
SHOW KEYS FROM table_name IN database_name

-- FILTER INDEX INFORMATION 
SHOW INDEXES FROM table_name WHERE condition;


SHOW INDEXES FROM table_name WHERE visible = 'NO';
--------------


CREATE TABLE leads(
    lead_id INT AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    information_source VARCHAR(255),
    INDEX name(first_name,last_name),
    UNIQUE email(email),
    PRIMARY KEY(lead_id)
);

DROP INDEX email ON leads ALGORITHM = INPLACE LOCK = DEFAULT;


CREATE TABLE t(
    pk INT PRIMARY KEY,
    c VARCHAR(10)
);

DROP INDEX `PRIMARY` ON table_name;

CREATE TABLE contacts(
    contact_id INT AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    PRIMARY KEY(contact_id),
    UNIQUE(email),
    INDEX phone(phone) INVISIBLE,
    INDEX name(first_name, last_name) comment 'By first name and/or last name'
);

SHOW INDEXES FROM table_name WHERE visible = 'NO';
-------------------------------------------

--- PREFIX INDEXES 

-- MySQL Prefix Index
-- When you create a secondary index for a column, MySQL stores the values of the columns in a separate data structure e.g., B-Tree and Hash.

-- In case the columns are the string columns, the index will consume a lot of disk space and potentially slow down the INSERT operations.

-- To address this issue, MySQL allows you to create an index for the leading part of the column values of the string columns using the following syntax:

    column_name(length)
-- In this syntax, 
-- the length is the number of characters for the non-binary string types such as CHAR, VARCHAR, and TEXT and the number of bytes for binary string types e.g., BINARY, VARBINARY, and BLOB.

-- MySQL allows you to optionally create column prefix key parts for CHAR, VARCHAR, BINARY, and VARBINARY columns. If you create indexes for BLOB and TEXT columns, you must specify the column prefix key parts.

-- Notice that the prefix support and lengths of prefixes if supported are storage engine dependent. For InnoDB tables with  REDUNDANT or COMPACT row format, the maximum prefix length is 767 bytes. However, for the InnoDB tables with  DYNAMIC or COMPRESSED row format, the prefix length is 3,072 bytes. MyISAM tables have the prefix length up to 1,000 bytes.


CREATE TABLE table_name(
    column_list,
    INDEX(column_name(length))
);

CREATE INDEX index_name ON table_name(column_name(length));

-- using products table
-- Find the products whose names start with string 

EXPLAIN FORMAT=JSON SELECT 
    productName,
    buyPrice,
    msrp
FROM 
    products
WHERE
    productName LIKE '1970%';

-- Evaluate different prefix length until I can achieve the responsible uniqueness of rows:

SELECT 
    COUNT(DISTINCT LEFT(productName, 20)) unique_rows
FROM 
    products;

CREATE INDEX idx_productName ON products(productName(20));

---------------------

---------------------------------------------------------
UNIQUE INDEX 


CREATE TABLE IF NOT EXISTS contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    UNIQUE KEY unique_email (email)
);


CREATE UNIQUE INDEX index_name ON table_name(col1, col2,...);

-- Add UNIQUE CONSTRAINT ON EXISTING TABLE

ALTER TABLE table_name ADD CONSTRAINT constraint_name UNIQUE KEY(col1, col2,...)

---------------------------
-- COMPOSITE INDEX 

CREATE TABLE table_name (
    c1 data_type PRIMARY KEY,
    c2 data_type,
    c3 data_type,
    c4 data_type,
    INDEX index_name (c2,c3,c4)
);


CREATE INDEX name ON employees(lastName, firstName);

firstName, lastName and email from employees where lastName is "Patterson"

----------------------------------
INVISIBLE 
-- Introduction to MySQL invisible index
-- The invisible indexes allow you to mark indexes as unavailable for the query optimizer. MySQL maintains the invisible indexes and keeps them up to date when the data in the columns associated with the indexes changes.

-- By default, indexes are visible. To make them invisible, you have to explicitly declare its visibility at the time of creation, or by using the ALTER TABLE command. MySQL provides us with the VISIBLE and INVISIBLE keywords to maintain index visibility.

CREATE INDEX index_name
ON table_name( c1, c2, ...) INVISIBLE;

-- In this syntax:

-- First, you specify the name of the index after the CREATE INDEX clause.
-- Second, you list the table name and the column list which you want to add to the index. The INVISIBLE keyword indicates that the index that you are creating is invisible.




CREATE INDEX index_name ON table_name(col1, col2) [ INVISIBLE | VISIBLE];

CREATE INDEX index_name ON table_name(col1, col2) INVISIBLE;

ALTER TABLE table_name ALTER INDEX index_name [ INVISIBLE | VISIBLE];

CREATE INDEX extension ON employees(extension) INVISIBLE;

ALTER TABLE  employees ALTER INDEX extension VISIBLE;

SELECT firstName FROM employees USE INDEX (extension) WHERE ...




--------------------------


----------------------------------------
-- Descending Index 

CREATE TABLE t(
    a INT NOT NULL,
    b INT NOT NULL,
    INDEX a_asc_b_desc (a ASC, b DESC)
);


DROP TABLE t;

CREATE TABLE t (
    a INT,
    b INT,
    INDEX a_asc_b_asc (a ASC , b ASC),
    INDEX a_asc_b_desc (a ASC , b DESC),
    INDEX a_desc_b_asc (a DESC , b ASC),
    INDEX a_desc_b_desc (a DESC , b DESC)
) ENGINE = InnoDB;

CREATE TABLE t (
    a INT,
    b INT,
    KEY a_asc_b_DESC (a, b DESC)
) ENGINE = InnoDB;


--------
A clustered index, on the other hand, is the table. 
It is an index that enforces the ordering on the rows of the table physically.

Once a clustered index is created, all rows in the table will be stored according to the key columns used to create the clustered index.

Because a clustered index store the rows in sorted order, each table have only one clustered index.
-------------------------------

SELECT firstName FROM employees FORCE INDEX (extension) WHERE condition;

SELECT 
    productName,
    buyPrice
FROM 
    products
WHERE 
    buyPrice BETWEEN 10 AND 80
ORDER BY buyPrice;


EXPLAIN FORMAT=JSON SELECT 
    productName,
    buyPrice
FROM 
    products
FORCE INDEX (idx_buyprice)
WHERE 
    buyPrice BETWEEN 10 AND 80
ORDER BY buyPrice;

CREATE INDEX idx_buyprice ON products(buyPrice);