SELECT company_name FROM customers
EXCEPT
SELECT company_name FROM suppliers;
