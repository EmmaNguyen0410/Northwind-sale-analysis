create view products_categories as 
select
    category_id,
    category_name, 
    product_id, 
    product_name,
    supplier_id,
    unit_in_stock, 
    unit_on_order, 
    reorder_level, 
    unit_price,
    discontinued
from
    public.categories 
    inner join public.products using(category_id)