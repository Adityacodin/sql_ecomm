use ecomm_db;

show tables;

desc addresses;
desc categories;
desc customers;
desc order_items;
desc orders;


alter table customers modify created_at datetime default now() not null;

SHOW CREATE TABLE order_items;

alter table order_items modify price_per_unit decimal(10,2) not null check(price_per_unit >= 0);

alter table orders  
	modify customer_id int not null,
	modify orderdate datetime default now() not null,
	modify status enum('pending','shipped','delivered','cancelled','returned') not null,
	modify total_amount decimal(10,2) not null CHECK(total_amount >= 0);

desc payments;
alter table payments
	modify order_id int not null,
	modify payment_method enum('upi','card_debit','card_credit','net_banking','wallet_paytm','wallet_phonepe','emi','bnpl','cod','neft','rtgs','cheque') not null, 
	modify payment_status enum('pending','authorized','paid','failed','refunded') not null,
	modify payment_date datetime default now() not null,
	modify amount decimal(10,2) not null check(amount >=0);  

desc products;
alter table products
	modify supplier_id int not null,
	modify category_id int not null,
	modify product_name varchar(100) not null,
	modify price decimal(10,2) not null CHECK(price >= 0),
	modify stock_quantity int not null check(stock_quantity >= 0),
	modify created_at datetime default now() not null;

desc suppliers;
alter table suppliers  
	modify supplier_name varchar(30) not null,
	modify contact_email varchar(50) unique not null;

desc addresses;

show tables;
desc addresses;

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

alter table customers 
modify email varchar(50) not null,
modify phone varchar(15) not null;

alter table customers
add constraint unique_customer_email UNIQUE(email),
add constraint unique_customer_phone  unique(phone);

alter table suppliers 
modify contact_email varchar(50) not null,

alter table suppliers
add constraint unique_supplier_email unique(contact_email);

desc order_items;
alter table order_items
add constraint unique_order_product_id unique(order_id,product_id);

SHOW CREATE TABLE orders;use ecomm_db;

show tables;

desc addresses;
desc categories;
desc customers;
desc order_items;
desc orders;

alter table customers modify created_at datetime default now() not null;

alter table order_items 
modify price_per_unit decimal(10,2) not null check(price_per_unit >= 0),
modify quantity int not null check(quantity>0);

alter table orders  
	modify customer_id int not null,
	modify orderdate datetime default now() not null,
	modify status enum('pending','shipped','delivered','cancelled','returned') not null,
	modify total_amount decimal(10,2) not null CHECK(total_amount >= 0);

desc payments;
alter table payments
	modify order_id int not null,
	modify payment_method enum('upi','card_debit','card_credit','net_banking','wallet_paytm','wallet_phonepe','emi','bnpl','cod','neft','rtgs','cheque') not null, 
	modify payment_status enum('pending','authorized','paid','failed','refunded') not null,
	modify payment_date datetime default now() not null,
	modify amount decimal(10,2) not null check(amount >=0);  

desc products;
alter table products
	modify supplier_id int not null,
	modify category_id int not null,
	modify product_name varchar(100) not null,
	modify price decimal(10,2) not null CHECK(price >= 0),
	modify stock_quantity int not null check(stock_quantity >= 0),
	modify created_at datetime default now() not null;

desc suppliers;
alter table suppliers  
	modify supplier_name varchar(30) not null,
	modify contact_email varchar(50) unique not null;

desc addresses;

show tables;
desc addresses;

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

alter table customers 
modify email varchar(50) not null,
modify phone varchar(15) not null;

alter table customers
add constraint unique_customer_email UNIQUE(email),
add constraint unique_customer_phone  unique(phone);

alter table suppliers 
modify contact_email varchar(50) not null,

alter table suppliers
add constraint unique_supplier_email unique(contact_email);

desc order_items;
alter table order_items
add constraint unique_order_product_id unique(order_id,product_id);

SHOW CREATE TABLE orders;

ALTER TABLE orders
DROP FOREIGN KEY ord_cust_fk;

ALTER TABLE orders
ADD CONSTRAINT ord_cust_fk
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE RESTRICT;


ALTER TABLE orders
DROP FOREIGN KEY ord_cust_fk;

ALTER TABLE orders
ADD CONSTRAINT ord_cust_fk
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
ON DELETE RESTRICT;

SHOW CREATE TABLE order_items;


