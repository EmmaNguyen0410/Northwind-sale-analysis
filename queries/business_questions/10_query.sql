with employees_with_full_name as (
    select
        employee_id,
        concat(first_name, ' ', last_name) as employee_full_name
    from
        public.employees
),
raw_table as (
    select
        c.category_id,
        category_name,
        employee_full_name,
        (sum(quantity * od.unit_price *(1 - discount))) as total_sale_amount
    from
        orders_order_details as ood
        inner join products_categories as pc on ood.product_id = pc.product_id
        inner join employees_with_full_name as e on e.employee_id = o.employee_id

    group by
        c.category_id,
        employee_full_name
),
employee_total_sale_all_categories as (
    select
        employee_full_name,
        sum(total_sale_amount) as total_sale_all_categories
    from
        raw_table
    group by
        employee_full_name
),
category_total_sale_all_employees as (
    select
        category_id,
        sum(total_sale_amount) as total_sale_all_employees
    from
        raw_table
    group by
        category_id
)
select
    raw_table.category_name,
    raw_table.employee_full_name,
    raw_table.total_sale_amount :: decimal(10, 2),
    (total_sale_amount / total_sale_all_categories) :: decimal(10, 5) as percent_of_employee_sales,
    (total_sale_amount / total_sale_all_employees) :: decimal(10, 5) as percent_of_category_sales
from
    raw_table
    inner join employee_total_sale_all_categories on raw_table.employee_full_name = employee_total_sale_all_categories.employee_full_name
    inner join category_total_sale_all_employees on raw_table.category_id = category_total_sale_all_employees.category_id
order by
    raw_table.category_name ASC,
    raw_table.total_sale_amount DESC;