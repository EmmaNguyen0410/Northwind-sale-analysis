select
    product_name,
    unit_price as product_unit_price
from
    public.products
where
    unit_price between 10
    and 50
    and discontinued = 0
order by
    product_name