with monthly_sales as (
    select
        product_id,
        product_name,
        to_char(order_date, 'yyyy-MM-01') as sales_month_year,
        sum(unit_price * quantity) as month_total_sales
    from
        orders_order_details_products
    group by
        product_id, product_name, to_char(order_date, 'yyyy-MM-01')
),
sales_trend_base as (
    select
        product_id,
        product_name,
        sales_month_year,
        month_total_sales,
        lead(month_total_sales) over (
            partition by product_id, product_name
            order by sales_month_year
        ) as next_month_total_sales
    from monthly_sales
),
sales_trend as (
    select
        *,
        case
            when month_total_sales > next_month_total_sales
            then 1 else 0
        end as is_declining
    from sales_trend_base
),
declining_months as (
    select
        product_id,
        product_name,
        sales_month_year,
        is_declining,
        row_number() over (partition by product_id order by sales_month_year)
            - row_number() over (partition by product_id, is_declining order by sales_month_year)
            as decline_group
    from sales_trend
    where is_declining = 1
)
select
    product_id,
    product_name
from
    declining_months
group by
    product_id, product_name, decline_group
having
    count(*) >= 3;
