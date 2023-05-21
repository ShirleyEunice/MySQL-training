-- Managing MySQL triggers:
    - Create triggers 
    - Drop triggers 
    - Create a BEFORE INSERT trigger
    - Create an AFTER INSERT trigger
    - Create a BEFORE UPDATE trigger
    - Create an AFTER UPDATE trigger 
    - Create a BEFORE DELETE trigger 
    - Create an AFTER DELETE trigger 
    - Create multiple triggers for a table that have the same trigger event and time
    - Show triggers - list triggers in a database, table by specific patterns.

/*
MySQL triggers are stored programs invoked automatically in response to an event 
such as insert, update, or delete that occurs in the associated table. 
For example, you can define a trigger that is invoked automatically before 
a new row is inserted into a table.

MySQL supports triggers that are invoked in response to the INSERT, UPDATE or DELETE event.

The SQL standard defines two types of triggers: row-level triggers and statement-level triggers.

A row-level trigger is activated for each row that is inserted, updated, or deleted. For example, if a table has 100 rows inserted, updated, or deleted, the trigger is automatically invoked 100 times for the 100 rows affected.

A statement-level trigger is executed once for each transaction regardless of how many rows are inserted, updated, or deleted.

*** MySQL supports only row-level triggers. It doesn’t support statement-level triggers.

--------------------------------------
***Advantages of triggers
    Triggers provide another way to check the integrity of data.

    Triggers handle errors from the database layer.

    Triggers give an alternative way to run scheduled tasks. By using triggers, you don’t have to wait for the scheduled events to run because the triggers are invoked automatically before or after a change is made to the data in a table.

    Triggers can be useful for auditing the data changes in tables.
--------------------------------------
***Disadvantages of triggers
    Triggers can only provide extended validations, not all validations. For simple validations, you can use the NOT NULL, UNIQUE, CHECK and FOREIGN KEY constraints.

    Triggers can be difficult to troubleshoot because they execute automatically in the database, which may not be visible to the client applications.

    Triggers may increase the overhead of the MySQL server.

*/

-------------------------------
/*
-- Create Trigger :

-- Syntax of the CREATE TRIGGER statement:
    CREATE TRIGGER trigger_name
    {BEFORE | AFTER} {INSERT | UPDATE| DELETE }
    ON table_name FOR EACH ROW
    trigger_body;

In this syntax:
    First, specify the name of the trigger that you want to create after the CREATE TRIGGER keywords. Note that the trigger name must be unique within a database.

    Next, specify the trigger action time which can be either BEFORE or AFTER which indicates that the trigger is invoked before or after each row is modified.

    Then, specify the operation that activates the trigger, which can be INSERT, UPDATE, or DELETE.

    After that, specify the name of the table to which the trigger belongs after the ON keyword.

    Finally, specify the statement to execute when the trigger activates. If you want to execute multiple statements, you use the BEGIN END compound statement.

The trigger body can access the values of the column being affected by the DML statement.

To distinguish between the value of the columns BEFORE and AFTER the DML has fired, 
we use the NEW and OLD modifiers.
*/

-- Create First Trigger
-- create a new table named employees_audit to keep the changes to the employees table

CREATE TABLE employees_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    changedat DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);

CREATE TRIGGER before_employee_update
    BEFORE UPDATE ON employees 
    FOR EACH ROW 
INSERT INTO employees_audit
SET action = 'update',
    employeeNumber = OLD.employeeNumber,
    lastname = OLD.lastname,
    changedat = NOW();

UPDATE employees SET lastname = "steve" WHERE employeeNumber=1056;

------------------------
SHOW TRIGGERS;
DROP TRIGGER IF EXISTS database_name.trigger_name;
-----------------------

wiley pulblications --> news letter 

Members tables 
    id, name, email, date_of_birth 

Register
INSERT 
    name, email, date_of_birth

REMINDER TABLE 
    id , member_id, message (Hi new.name, please update your date_of_birth)

DELIMITER $$
CREATE TRIGGER after_members_insert 
AFTER INSERT 
ON members FOR EACH ROW 
BEGIN
    IF NEW.date_of_birth IS NULL THEN
        INSERT INTO reminders(member_id, message)
        VALUES(NEW.id, CONCAT('Hi ', NEW.name, ', please update your dob,') );
    END IF;
END $$
DELIMITER ;

---------------------------------------

Bank 

customers 
    id
    name
    email 
    phone 
    extra_payment
    emi_amount 
    
monthly customer pay the emi (10k)

extra_payment can not be more than 2 times of monthly emi

create trigger before_additonal_payment 

BEFORE UPDATE 

DECLARE error message and return that error message 

update customers set extra_payment = 30000 where id = 1;

ErrorCode : 1644 : the new extra_payment should not be more than 2 emi amount 
.....

IF extra_payment > emi * 2
    SIGNAL SQLSTATE '45000'  SET MESSAGE_TEXT = errorMessage




