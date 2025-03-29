With employee_sales as (
       select
              concat(first_name, ' ', last_name) as employee_full_name,
              title as employee_title,
              sum(unit_price * quantity) :: decimal(10, 2) as total_sale_amount_excluding_discount,
              count(distinct(o.order_id)) as number_unique_orders,
              count(o.order_id) as number_orders,
              (sum(unit_price * quantity) / sum(quantity)) :: decimal(10, 2) as average_product_amount,
              (
                     sum(unit_price * quantity) / count(distinct(o.order_id))
              ) :: decimal(10, 2) as average_order_amount,
              (sum(unit_price * quantity * od.discount)) :: decimal(10, 2) as total_discount_amount,
              (sum(unit_price * quantity *(1 - od.discount))) :: decimal(10, 2) as total_sale_amount_including_discount,
              (
                     sum(unit_price * quantity * od.discount) / sum(unit_price * quantity) * 100
              ) :: decimal(10, 2) as total_discount_percentage
       from
              order_details as od
              inner join orders as o on od.order_id = o.order_id
              inner join employees as e on o.employee_id = e.employee_id
       group by
              e.employee_id
)
select
       *
from 
       employee_sales
order by
       total_sale_amount_including_discount desc