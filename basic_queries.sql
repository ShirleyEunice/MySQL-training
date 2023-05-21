-- Qyerying the data
-- Sorting the data
-- Filter data
-- Joins
-- Groups Data
-- SubQueries
-- CME common table expression
-- Set operators
-- Modify data
-- MySQL Transaction
-- Manage database
-- ....


-- Connect to MySQL
mysql -u root -p

-- show databases
show databases;

-- load existing database 

source path\yourdb.sql

-- Create db
create database database_name;

-- drop db
drop database database_name

-- use/select db
use database_name

/* Create Table*/
create table course_list (
    course_id INT NOT NULL AUTO_INCREMENT,
    course_title VARCHAR(100) NOT NULL,
    course_author VARCHAR(40) NOT NULL,
    creation_date DATE,
    PRIMARY KEY (course_id)
);

/* Drop Table*/
drop table course_list;

/** Insert into table **/

INSERT INTO course_list (course_title, course_author, creation_date) 
    VALUES
    ("Java", "Venkat", NOW()),
    ("Python", "Trupthi", NOW()),
    ("MySQL", "Deepak", NOW());

-- Querying Data
-- Select queries 

SELECT select_list FROM table_name;

SELECT lastName
FROM employees;

SELECT 
    lastName, 
    firstName, 
    jobTitle
FROM
    employees;
    
SELECT * 
FROM employees;

SELECT 1 + 1;    

SELECT NOW();

SELECT CONCAT('John',' ','Doe');

-- column alias
SELECT expression AS column_alias;
SELECT CONCAT('John',' ','Doe') AS name;
SELECT CONCAT('Jane',' ','Doe') AS 'Full name';

