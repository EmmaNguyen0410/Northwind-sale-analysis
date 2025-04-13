select 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    p.product_id,
    p.product_name
from 
    employees e
cross join 
    products p
where 
    not exists (
        select 1
        from orders o
        join order_details od on o.order_id = od.order_id
        where 
            o.employee_id = e.employee_id
            and od.product_id = p.product_id
    )
order by 
    employee_name;

