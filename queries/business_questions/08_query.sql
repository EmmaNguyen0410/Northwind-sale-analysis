with category_prices as (
    select
        category_id,
        avg(unit_price) as average_unit_price,
        percentile_cont(0.5) WITHIN GROUP(
            ORDER BY
                unit_price
        ) as median_unit_price
    from
        public.products
    where
        discontinued = 0
    group by
        category_id
)
select
    category_name,
    product_name,
    unit_price,
    average_unit_price :: decimal(5, 2),
    median_unit_price :: decimal(5, 2),
    case
        when unit_price < category_prices.average_unit_price then 'Below Average'
        when unit_price = category_prices.average_unit_price then 'Average'
        when unit_price > category_prices.average_unit_price then 'Over Average'
    end as average_unit_price_position,
    case
        when unit_price < category_prices.median_unit_price then 'Below Median'
        when unit_price = category_prices.median_unit_price then 'Median'
        when unit_price > category_prices.median_unit_price then 'Over Median'
    end as median_unit_price_position
from
    products_categories as pc
    inner join category_prices on pc.category_id = category_prices.category_id
where 
    pc.discontinued = 0
order by 
    category_name,
    product_name