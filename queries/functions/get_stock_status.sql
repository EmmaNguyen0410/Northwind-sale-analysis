create function getStockStatus(int)  
returns text   
language plpgsql  
as $$  
declare  
    stock int;  
    status text;  
begin  
    -- Get stock quantity  
    select unit_in_stock into stock from products where products.product_id = $1;  

    -- Determine stock status  
    IF stock IS NULL THEN  
        status := 'Product Not Found';  
    ELSIF stock = 0 THEN  
        status := 'Out of Stock';  
    ELSIF stock < 10 THEN  
        status := 'Low Stock';  
    ELSE  
        status := 'In Stock';  
    END IF;  

    RETURN status;  
END;  
$$;  

