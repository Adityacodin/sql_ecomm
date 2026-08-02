CREATE database ecomm_db;

use ecomm_db;

CREATE TABLE customers(
	customer_id int primary key auto_increment,
	first_name varchar(25) not null,
	last_name varchar(25) not null,
	email varchar(50) UNIQUE NOT NULL,
	phone varchar(15) UNIQUE NOT NULL,
	created_at DATETIME DEFAULT NOW() not null
);

ALTER TABLE customers AUTO_INCREMENT = 100;

CREATE TABLE addresses (
address_id int primary key auto_increment,
customer_id int not null,
city varchar(20) not null,
state varchar(20) not null,
country varchar(20) not null,
postal_code varchar(20) not null
);

ALTER TABLE addresses AUTO_INCREMENT = 100;

CREATE TABLE categories(
category_id int primary key auto_increment,
category_name varchar(25) not null
);

alter table categories auto_increment = 100;

create table suppliers(
supplier_id int primary key auto_increment,
supplier_name varchar(30) not null ,
contact_email varchar(50) UNIQUE NOT NULL
);

alter table suppliers auto_increment = 100;

create table products(
product_id int primary key auto_increment,
category_id int not null,
supplier_id int not null,
product_name varchar(30) not null,
price decimal(10,2) not null,
stock_quantity int not null,
created_at datetime default now() not null
);

alter table products auto_increment = 100;

create table orders(
order_id int primary key auto_increment not null,
customer_id int not null,
orderdate datetime default now() not null,
status enum("pending","shipped","delivered","cancelled","returned") not null,
total_amount decimal(10,2) not null
);

alter table orders auto_increment = 100;

create table order_items(
	order_item_id int primary key auto_increment,
	order_id int not null,
	product_id int not null,
	quantity int not null,
	price_per_unit decimal(10,2) not null
);

alter table order_items auto_increment = 100;

create table payments(
payment_id int primary key auto_increment,
order_id int not null,
payment_method ENUM('upi', 'card_debit', 'card_credit', 'net_banking', 'wallet_paytm', 'wallet_phonepe', 'emi', 'bnpl', 'cod', 'neft', 'rtgs', 'cheque'),
payment_status ENUM('pending', 'authorized', 'paid', 'failed', 'refunded') not null,
payment_date datetime default now() not null,
amount decimal(10,2) not null
);

alter table payments auto_increment = 100;
