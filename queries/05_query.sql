with temp as (
    select
        distinct *
    from
        (
            select
                product_id,
                unit_price,
                dense_rank() over (
                    partition by product_id
                    order by
                        order_date ASC
                ) rank1,
                dense_rank() over (
                    partition by product_id
                    order by
                        order_date DESC
                ) rank2
            from
                public.orders as o
                inner join order_details as od on o.order_id = od.order_id
        ) sub
    where
        rank1 = 1
        or rank2 = 1
)
select
    product_name,
    current_price :: decimal(5, 2),
    previous_unit_price :: decimal(5, 2),
    percentage_increase :: decimal(10, 4)
from
    (
        select
            product_name,
            t2.unit_price as current_price,
            t1.unit_price as previous_unit_price,
            (t2.unit_price / t1.unit_price - 1) * 100 as percentage_increase
        from
            temp as t1
            inner join temp as t2 on t1.product_id = t2.product_id
            and t1.rank1 < t2.rank1
            inner join products as p on p.product_id = t1.product_id
    ) sub
where
    (
        percentage_increase > 0
        and percentage_increase < 10
    )
    or percentage_increase > 30
order by
    percentage_increase