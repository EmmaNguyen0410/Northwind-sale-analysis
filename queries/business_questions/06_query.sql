with order_details_enriched as (
    select
        category_name,
        order_id,
        (od.unit_price * od.quantity) * (1 - od.discount) as amount,
        case
            when od.unit_price < 10 then '1. Below $10'
            when od.unit_price <= 20 then '2. $10 - $20'
            when od.unit_price <= 50 then '3. $20 - $50'
            when od.unit_price > 50 then '4. Over $50'
        end as price_range
    from
        products_categories as pc
        inner join public.order_details as od on pc.product_id = od.product_id
)
select
    category_name,
    price_range,
    sum(amount) :: decimal(10, 2) as total_amount,
    count(distinct(order_id)) as total_number_orders
from 
    order_details_enriched
group by
    category_name,
    price_range
order by
    category_name,
    price_range