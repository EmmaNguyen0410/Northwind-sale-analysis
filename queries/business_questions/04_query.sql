select
      year_month,
      total_number_orders,
      total_freight :: decimal(5, 0) as total_freight
from
      (
            select
                  year_month,
                  count(*) as total_number_orders,
                  sum(freight) as total_freight
            from
                  (
                        select
                              freight,
                              to_char(order_date, 'yyyy-MM-01') as year_month
                        from
                              orders
                        where
                              extract(
                                    year
                                    from
                                          order_date
                              ) between 1996
                              and 1997
                  ) orders_with_year_month
            group by
                  year_month
      ) sub
where
      total_freight > 2500
      and total_number_orders > 20
order by
      total_freight DESC;