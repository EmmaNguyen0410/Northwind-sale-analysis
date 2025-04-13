create function getStockStatus(p_product_id int)
returns text
language plpgsql
as $$
declare
    stock int;
    status text;
begin
    -- Get stock quantity
    select unit_in_stock into stock
    from products
    where product_id = p_product_id;

    -- Determine stock status
    if stock is null then
        status := 'Product Not Found';
    elsif stock = 0 then
        status := 'Out of Stock';
    elsif stock < 10 then
        status := 'Low Stock';
    else
        status := 'In Stock';
    end if;

    return status;
end;
$$;
