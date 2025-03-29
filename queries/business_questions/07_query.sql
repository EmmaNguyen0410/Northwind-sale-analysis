with categorised_suppliers as (
    select
        category_name,
        unit_in_stock,
        unit_on_order,
        reorder_level,
        case
            when s.country in ('USA', 'Canada', 'Brazil') then 'America'
            when s.country in ('Japan', 'Singapore') then 'Asia'
            when s.country = 'Australia' then 'Oceania'
            else 'Europe'
        end as supplier_region
    from
        public.products as p
        inner join public.suppliers as s on p.supplier_id = s.supplier_id
        inner join public.categories as c on p.category_id = c.category_id
),
grouped_by_category_name_supplier_region as (
    select
        category_name,
        supplier_region,
        sum(unit_in_stock) as units_in_stock,
        sum(unit_on_order) as units_on_order,
        sum(reorder_level) as reorder_level
    from 
        categorised_suppliers
    group by 
        category_name,
        supplier_region
)
select * 
from 
    grouped_by_category_name_supplier_region
order by 
    supplier_region,
    category_name,
    reorder_level;