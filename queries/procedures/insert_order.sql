create procedure insertOrder(
    in p_customer_id bpchar,
    in p_employee_id INT,
    in p_freight REAL, 
    in p_ship_name VARCHAR(40),
    in p_ship_address VARCHAR(60),
    in p_ship_city VARCHAR(15),
    in p_ship_region VARCHAR(15),
    in p_ship_postal_code VARCHAR(10),
    in p_ship_country VARCHAR(15),
    in p_product_id INT,
    in p_quantity INT,
    in p_unit_price REAL,
    in p_discount REAL
)
language plpgsql
as $$
declare
    order_id int; 
    available_stock int;
begin 
    -- Start transaction
    begin
        -- Check product availability 
        select unit_in_stock into available_stock
        from products
        where product_id = p_product_id;

        if available_stock is NULL then 
            raise exception 'Product not found';
        end if;

        if available_stock < p_quantity then 
            raise exception 'Insufficient stock';
        end if;

        -- Generate new order_id (only if not auto-incremented)  
        select coalesce(max(order_id), 0) + 1 into order_id from orders;

        -- Insert new order 
        insert into orders (order_id, customer_id, employee_id, order_date, freight, ship_name, ship_address, ship_city, ship_region, ship_postal_code, ship_country)
        values (order_id, p_customer_id, p_employee_id, CURRENT_DATE, p_freight, p_ship_name, p_ship_address, p_ship_city, p_ship_region, p_ship_postal_code, p_ship_country);

        -- Insert order_details 
        insert into order_details(order_id, product_id, unit_price, quantity, discount)
        values (order_id, p_product_id, p_unit_price, p_quantity, p_discount);

        -- Update product stock 
        update products
        set unit_in_stock = unit_in_stock - p_quantity 
        where product_id = p_product_id; 

        commit; 
        raise notice 'Order placed successfully';
    exception
        when others then 
            rollback;
            raise exception 'Error: % ', SQLERRM;
    end;
end;
$$;

-- call PlaceNewOrder( 
--     'BONAP', -- customer_id 
--     2,      -- employee_id
--     10.50,  -- freight
--     'Fast Delivery',
--     '123 Main St',
--     'New York',
--     'NY',
--     '10001',
--     'USA',
--     5,      -- product_id
--     10,     -- quantity
--     20.50,  -- unit_price
--     0.05    -- discount
-- );




