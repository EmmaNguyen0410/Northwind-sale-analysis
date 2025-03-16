select
    category_name,
    product_name,
    unit_price,
    average_unit_price :: decimal(5, 2),
    median_unit_price :: decimal(5, 2),
    case
        when unit_price < sub.average_unit_price then 'Below Average'
        when unit_price = sub.average_unit_price then 'Average'
        when unit_price > sub.average_unit_price then 'Over Average'
    end as average_unit_price_position,
    case
        when unit_price < sub.median_unit_price then 'Below Median'
        when unit_price = sub.median_unit_price then 'Median'
        when unit_price > sub.median_unit_price then 'Over Median'
    end as median_unit_price_position
from
    public.products as p
    inner join public.categories as c on p.category_id = c.category_id
    inner join (
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
    ) as sub on p.category_id = sub.category_id
where
    p.discontinued = 0
order by
    category_name,
    product_name