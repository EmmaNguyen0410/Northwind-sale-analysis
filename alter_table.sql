-- add foreign keys for products table 
ALTER TABLE public.products
ADD FOREIGN KEY (category_id) REFERENCES public.categories(category_id);

ALTER TABLE public.products
ADD FOREIGN KEY (supplier_id) REFERENCES public.suppliers(supplier_id);

-- add foreign keys for order_details table
ALTER TABLE public.order_details
ADD FOREIGN KEY (product_id) REFERENCES public.products(product_id);

ALTER TABLE public.order_details
ADD FOREIGN KEY (order_id) REFERENCES public.orders(order_id);

-- add foreign keys for customer_customer_demo table
ALTER TABLE public.customercustomerdemo
ADD FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);

ALTER TABLE public.customercustomerdemo
ADD FOREIGN KEY (customer_type_id) REFERENCES public.customerdemographics(customer_type_id);

-- add foreign keys for orders table
ALTER TABLE public.orders
ADD FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);

ALTER TABLE public.orders
ADD FOREIGN KEY (ship_via) REFERENCES public.shippers(shipper_id);

ALTER TABLE public.orders
ADD FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);

-- add foreign keys for employees table
ALTER TABLE public.employees
ADD FOREIGN KEY (reports_to) REFERENCES public.employees(employee_id);


-- add foreign keys for employee_territories table
ALTER TABLE public.employeeterritories
ADD FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);

ALTER TABLE public.employeeterritories
ADD FOREIGN KEY (territory_id) REFERENCES public.territories(territory_id);

-- add foreign keys for territories table
ALTER TABLE public.territories
ADD FOREIGN KEY (region_id) REFERENCES public.region(region_id);