with monthly_sales as (
    select
        product_id, 
        product_name,
        to_char(order_date, 'yyyy-MM-01') as sales_month_year,
        sum(unit_price * quantity) as month_total_sales
    from order_details
    join orders using(order_id)
    join products using(product_id)
    group by product_id, product_name, sales_month_year
), 
sales_trend as (
    select 
        product_id, 
        product_name,
        sales_month_year,
        total_sales,
        lead(total_sales) over (partition by product_id, product_name order by sales_month_year) as next_month_total_sales,
        case 
            when month_total_sales > next_month_total_sales
            then 1 else 0
        end as is_declining
    from monthly_sales
),
declining_months (
    select 
        product_id, 
        product_name,
        sales_month_year,
        row_number() over (partition by product_id order by sales_month_year) - row_number() over (partition by product_id, is_declining order by sales_month_year) as decline_group
    from sales_trend
)
select 
    product_id, 
    product_name
from 
    declining_months
group by 
    decline_group
having 
    count(*) >= 3


