/* Normalization is the process of organizing data in a database to eliminate redundancy 
 and dependency issues. It involves breaking down a database into multiple tables
 and defining relationships between them.
 The normal forms (1NF, 2NF, 3NF, 4NF, 5NF, and BCNF) are guidelines 
 that help ensure data integrity and minimize anomalies. */

First Normal Form (1NF):

-- Each attribute (column) in a table must hold only atomic (indivisible) values.
-- There should be no repeating groups or arrays within a table.
-- Example: Suppose we have a table named "Students" with the following columns: 
    -- Student_ID, Name, and Subjects. In 1NF, we need to eliminate the repeating group. 
    -- We can achieve this by creating a separate table for subjects and
    --  referencing it using the student's ID.

-- Students Table:

Student_ID	Name	Subjects
1	John	Math,   Science, History
2	Alice	Math,   English

-- Subjects Table:

Student_ID	Subject
1	    Math
1	    Science
1	    History
2	    Math
2	    English

-------------------------------------------------------------------------------
-- Second Normal Form (2NF):

-- The table must already be in 1NF.
-- All non-key attributes (columns) should depend on the whole primary key.

Example: Consider a table called "Orders" with columns: Order_ID, Product_ID, Product_Name, and Product_Category. In 2NF, we need to ensure that the Product_Name and Product_Category depend on the Order_ID and not just the Product_ID.

-- Orders Table:
Order_ID	Product_ID	Product_Name	Product_Category
1	        101	        Laptop	        Electronics
1	        102	        Printer	        Electronics
2	        103	        Shirt	        Clothing

-- Products Table:
Product_ID	Product_Name	Product_Category
101	        Laptop	        Electronics
102	        Printer	        Electronics
103	        Shirt	        Clothing

-------------------------------------------------------------------------------
-- Third Normal Form (3NF):

-- The table must already be in 2NF.
-- There should be no transitive dependencies, i.e., no non-key attributes should depend on other non-key attributes.

-- Example: Let's consider a table called "Employees" with columns: Employee_ID, Department_ID, Department_Name, and Manager. In 3NF, we need to separate the Manager information into a separate table as it depends on the Department_ID and not directly on the Employee_ID.

-- Employees Table:
Employee_ID	Department_ID	Department_Name	    Manager
1	        101	            Sales	            John
2	        101	            Sales	            Alice
3	        102	            Marketing	        Bob

-- Departments Table:
Department_ID	Department_Name
101	            Sales
102	            Marketing

-- Managers Table:
Department_ID	Manager
101	            John
102	            Bob
101	            Alice

----------------------------------------------------------------------

-- Boyce-Codd Normal Form (BCNF):

-- The table must already be in 3NF.
-- Every determinant (attribute determining another attribute) must be a candidate key.

-- Example: Let's consider a table called "Customers" with columns: Customer_ID, Product_ID, and Product_Name. In BCNF, we need to split the table into two tables: Customers and Products, as the Product_Name depends on the Product_ID and not on the Customer_ID.

-- Customers Table:
Customer_ID	Product_ID
1	        101
2	        102

-- Products Table:
Product_ID	Product_Name
101	        Laptop
102	        Printer

----------------------------------------------------------------------
-- Fourth Normal Form (4NF):

-- The table must already be in BCNF.
-- It addresses multi-valued dependencies, where a set of attributes depends on another set of attributes.

-- Example: Consider a table called "Employees_Projects" with columns: Employee_ID, Project_ID, Employee_Name, Project_Name, and Hours_Worked. In 4NF, we need to separate the multi-valued dependency between Employee_ID, Employee_Name, and Hours_Worked.

-- Employees_Projects Table:
Employee_ID	Project_ID	Employee_Name	Project_Name	Hours_Worked
1	        101	        John	        Project A	    40
1	        102	        John	        Project B	    30
2	        101	        Alice	        Project A	    25

-- Employees Table:
Employee_ID	Employee_Name
1	        John
2	        Alice

-- Projects Table:
Project_ID	Project_Name
101	        Project A
102     	Project B

----------------------------------------------------------------------
-- Fifth Normal Form (5NF):

-- The table must already be in 4NF.
-- It addresses join dependencies, where data can be derived by joining multiple tables.

-- Example: Suppose we have a table called "Authors_Books" 
    -- with columns: Author_ID, Book_ID, Author_Name, Book_Name, 
    -- and Genre. In 5NF, we need to separate the join dependency 
    -- between Author_ID, Author_Name, and Genre.

-- Authors_Books Table:
Author_ID	Book_ID	Author_Name	Book_Name	Genre
1	        101	    John	    Book A	    Fiction
1	        102	    John	    Book B	    Mystery
2	        103	    Alice	    Book C	    Romance

-- Authors Table:
Author_ID	Author_Name
1	        John
2	        Alice

-- Books Table:
Book_ID	Book_Name	Genre
101	    Book A	    Fiction
102 	Book B	    Mystery
103	    Book C	    Romance
