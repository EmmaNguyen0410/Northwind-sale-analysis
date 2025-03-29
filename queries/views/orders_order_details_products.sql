create view orders_order_details_products as 
select
    product_id, 
    product_name,
    order_date,
    order_details.unit_price,
    quantity
from order_details
inner join orders using(order_id)
inner join products using(product_id)