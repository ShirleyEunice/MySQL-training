customers , payments 

query and return data from both the tables using inner join 

store a query in to file 

name your query Query 

view 

CREATE VIEW customerPayments 
AS 
SELECT 
    customerName,
    checkNumber,
    paymentDate,
    amount
FROM 
    customers 
INNER JOIN 
    payments USING(customerNumber);




