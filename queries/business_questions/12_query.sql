with yearly_sales as (
    select 
        date_part(order_date) as sales_month,
        date_part(order_date) as sales_year, 
        sum(unit_price * quantity) as month_total_sales
    from order_details
    join orders using(order_id)
    group by sales_month, sales_year
), sales_trend as (
    select 
        sales_month, 
        sales_year, 
        total_sales,
        lag(total_sales) over (partition by sales_year order by sales_month) as prev_month_total_sales,
        case 
            when month_total_sales < prev_month_total_sales
            then 1 else 0
        end as is_declining
    from yearly_sales
)
select 
    sales_month
from sales_trend
group by sales_month
having sum(is_declining) >= 4;
