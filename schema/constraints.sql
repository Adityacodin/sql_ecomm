show tables;

SHOW CREATE TABLE addresses;
SHOW CREATE TABLE categories;
SHOW CREATE TABLE customers;
SHOW CREATE TABLE order_items;
SHOW CREATE TABLE orders;
SHOW CREATE TABLE payments;
SHOW CREATE TABLE suppliers;
SHOW CREATE TABLE products;

alter table order_items 
add constraint check_ppu check (price_per_unit >= 0),
add constraint check_quant check (quantity>0);

alter table orders  
	add constraint check_total_amount CHECK (total_amount >= 0);

desc payments;
alter table payments
	add constraint check_amount check (amount >=0);  

desc products;
alter table products
	add constraint check_price CHECK (price >= 0),
	add constraint check_stock_quantity check (stock_quantity >= 0);


alter table addresses 
add constraint addr_cust_fk
foreign key (customer_id) 
references customers(customer_id)
on delete cascade; -- since theres no use of addresses if theres no customer record in the customers table

desc orders;
alter table orders 
add constraint ord_cust_fk
foreign key (customer_id) 
references customers(customer_id)
on delete restrict; -- since we cannot allow the customer records to be deleted if it has orders in orders table

alter table order_items  
add constraint ord_fk
foreign key (order_id) 
references orders(order_id)
on delete cascade; -- since theres no use of order_item records if theres no record in the orders table

alter table order_items  
add constraint prd_fk
foreign key (product_id) 
references products(product_id)
on delete restrict;

alter table payments  
add constraint pym_ord_fk
foreign key (order_id) 
references orders(order_id)
on delete restrict;

alter table products  
add constraint cat_fk
foreign key (category_id) 
references categories(category_id)
on delete restrict;

alter table products  
add constraint spl_fk
foreign key (supplier_id) 
references suppliers(supplier_id)
on delete restrict;

desc order_items;
alter table order_items
add constraint unique_order_product_id unique(order_id,product_id);

SHOW CREATE TABLE orders;
