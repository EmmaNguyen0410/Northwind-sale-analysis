with yearly_sales as (
    select
        product_id,
        product_name,
        date_part('month', order_date) as sales_month,
        date_part('year', order_date) as sales_year,
        sum(unit_price * quantity) as month_total_sales
    from
        orders_order_details_products
    group by
        product_id, product_name, date_part('month', order_date), date_part('year', order_date)
), sales_trend_base as (
    select
        product_id,
        product_name,
        sales_month,
        sales_year,
        month_total_sales,
        lag(month_total_sales) over (
            partition by product_id, product_name, sales_year
            order by sales_month
        ) as prev_month_total_sales
    from yearly_sales
), sales_trend as (
    select *,
        case
            when month_total_sales < prev_month_total_sales
            then 1 else 0
        end as is_declining
    from sales_trend_base
)
select
    product_id,
    product_name,
    sales_month
from sales_trend
group by product_id, product_name, sales_month
having sum(is_declining) >= 2;
