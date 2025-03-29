create view orders_order_details as 
select
    order_id, 
    order_date, 
    employee_id,
    product_id, 
    unit_price, 
    quantity,
    discount
from
    orders
    inner join order_details using(order_id)
