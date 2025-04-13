select
    c.country as country,
    c.company_name as customer_name,
    s.company_name as supplier_name
from
    customers c
full join
    suppliers s on c.country = s.country
where c.company_name is null or s.company_name is null
order by
    country;
