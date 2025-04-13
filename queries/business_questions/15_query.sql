select 
    contact_name, 
    contact_title,
    company_name,
    phone,
    'Customer' as source
from customers

union 

select 
    contact_name, 
    contact_title,
    company_name,
    phone, 
    'Supplier' as source
from suppliers;