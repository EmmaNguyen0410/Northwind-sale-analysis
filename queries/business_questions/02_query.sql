with shipping_stats as (
     select ship_country as shipping_country,
          avg(shipped_date - order_date)::decimal(5, 2) as average_days_between_order_shipping,
          count(*) as total_volume_number
     from orders
     where order_date >= '1997-01-01' AND order_date < '1998-01-01'
     group by ship_country
)
select * from 
shipping_stats
where total_volume_number > 5 and average_days_between_order_shipping >= 3 and average_days_between_order_shipping < 20
order by average_days_between_order_shipping DESC;