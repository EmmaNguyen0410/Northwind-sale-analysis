create or replace procedure placeNewOrder(
    in customer_id bpchar,
    in employee_id INT,
    in freight REAL, 
    in ship_name VARCHAR(40),
    in ship_address VARCHAR(60),
    in ship_city VARCHAR(15),
    in ship_region VARCHAR(15),
    in ship_postal_code VARCHAR(10),
    in ship_country VARCHAR(15),
    in product_id INT,
    in quantity INT,
    in unit_price REAL,
    in discount REAL
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
        where product_id = product_id;

        if available_stock is NULL then 
            raise exception 'Product not found';
        end if;

        if available_stock < quantity then 
            raise exception 'Insufficient stock';
        end if;

        -- Insert new order 
        select coalesce(max(order_id), 0) + 1 into order_id from orders;
        insert into orders (customer_id, employee_id, freight, ship_name, ship_address, ship_city, ship_region, ship_postal_code, ship_country)
        values (customer_id, employee_id, CURRENT_DATE, freight, ship_name, ship_address, ship_city, ship_region, ship_postal_code, ship_country);

        -- Insert order_details 
        insert into order_details(order_id, product_id, unit_price, quantity, discount)
        values order_details(order_id, product_id, unit_price, quantity, discount);

        -- Update product stock 
        update products
        set unit_in_stock = unit_in_stock - quantity 
        where product_id = product_id; 

        commit; 
        raise notice 'Order placed successfully';
    exception
        when others then 
            rollback;
            raise notice 'Error: % ', SQLERRM;
    end;
end;
$$;

call PlaceNewOrder( 
    'BONAP', -- customer_id 
    2,      -- employee_id
    10.50,  -- freight
    'Fast Delivery',
    '123 Main St',
    'New York',
    'NY',
    '10001',
    'USA',
    5,      -- product_id
    10,     -- quantity
    20.50,  -- unit_price
    0.05    -- discount
);




