CREATE database ecomm_db;

use ecomm_db;

CREATE TABLE customers(
	customer_id int primary key auto_increment,
	first_name varchar(25),
	last_name varchar(25),
	email varchar(50),
	phone varchar(15),
	created_at DATETIME DEFAULT NOW()
);

ALTER TABLE customers AUTO_INCREMENT = 100;

CREATE TABLE addresses (
	address_id int primary key auto_increment,
	customer_id int,
	city varchar(20),
	state varchar(20),
	country varchar(20),
	postal_code varchar(20),
	FOREIGN KEY (customer_id)  references customers(customer_id)
);

ALTER TABLE addresses AUTO_INCREMENT = 100;

CREATE TABLE categories(
	category_id int primary key auto_increment,
	category_name varchar(25)
);

alter table categories auto_increment = 100;

create table suppliers(
	supplier_id int primary key auto_increment,
	supplier_name varchar(30),
	contact_email varchar(50)
);

alter table suppliers auto_increment = 100;

create table products(
	product_id int primary key auto_increment,
	category_id int,
	supplier_id int,
	product_name varchar(30),
	price decimal(10,2),
	stock_quantity int,
	created_at datetime,
	Foreign key (category_id) references categories(category_id),
	foreign key(supplier_id) references suppliers(supplier_id)
);

alter table products auto_increment = 100;

create table orders(
	order_id int primary key auto_increment,
	customer_id int,
	orderdate datetime,
	status enum("pending","shipped","delivered"),
	total_amount decimal(10,2),
	foreign key (customer_id) references customers(customer_id)
);

alter table orders auto_increment = 100;

create table order_items(
	order_item_id int primary key auto_increment,
	order_id int,
	product_id int,
	quantity int,
	price_per_unit decimal(10,2),
	foreign key (order_id) references orders(order_id),
	foreign key (product_id) references products(product_id)
);

alter table order_items auto_increment = 100;

create table payments(
	payment_id int primary key auto_increment,
	order_id int,
	payment_method ENUM('upi', 'card_debit', 'card_credit', 'net_banking', 'wallet_paytm', 'wallet_phonepe', 'emi', 'bnpl', 'cod', 'neft', 'rtgs', 'cheque'),
	payment_status ENUM('pending', 'authorized', 'paid', 'failed', 'refunded'),
	payment_date datetime,
	amount decimal(10,2),
	foreign key (order_id) references orders(order_id)
);

alter table payments auto_increment = 100;



