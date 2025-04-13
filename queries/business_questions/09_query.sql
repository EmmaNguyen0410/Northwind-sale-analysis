With employee_sales as (
       select
              concat(first_name, ' ', last_name) as employee_full_name,
              title as employee_title,
              sum(unit_price * quantity) :: decimal(10, 2) as total_sale_amount_excluding_discount,
              count(distinct(ood.order_id)) as number_unique_orders,
              count(ood.order_id) as number_orders,
              (sum(unit_price * quantity) / sum(quantity)) :: decimal(10, 2) as average_product_amount,
              (
                     sum(unit_price * quantity) / count(distinct(ood.order_id))
              ) :: decimal(10, 2) as average_order_amount,
              (sum(unit_price * quantity * ood.discount)) :: decimal(10, 2) as total_discount_amount,
              (sum(unit_price * quantity *(1 - ood.discount))) :: decimal(10, 2) as total_sale_amount_including_discount,
              (
                     sum(unit_price * quantity * ood.discount) / sum(unit_price * quantity) * 100
              ) :: decimal(10, 2) as total_discount_percentage
       from
              orders_order_details as ood
              inner join employees as e on ood.employee_id = e.employee_id
       group by
              e.employee_id
)
select
       *
from 
       employee_sales
order by
       total_sale_amount_including_discount desc