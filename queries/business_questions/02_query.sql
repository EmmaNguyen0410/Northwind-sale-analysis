select * from (
     select ship_country as shipping_country,
          avg(shipped_date - order_date)::decimal(5, 2) as average_days_between_order_shipping,
          count(*) as total_volume_number
     from orders
     where extract(year from order_date) = 1997
     group by ship_country
) sub
where total_volume_number > 5 and average_days_between_order_shipping >= 3 and average_days_between_order_shipping < 20
order by average_days_between_order_shipping DESC;