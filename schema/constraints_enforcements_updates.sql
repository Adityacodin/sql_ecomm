USE ecomm_db;
SHOW TABLES;


--Outputs the exact CREATE TABLE command along with constraints.

SHOW CREATE TABLE addresses;
SHOW CREATE TABLE categories;
SHOW CREATE TABLE customers;
SHOW CREATE TABLE order_items;
SHOW CREATE TABLE orders;
SHOW CREATE TABLE payments;
SHOW CREATE TABLE products;
SHOW CREATE TABLE suppliers; 

-- Updates to the addresses table
ALTER TABLE
    addresses
MODIFY
    address_line1 VARCHAR(100) NOT NULL,
MODIFY
    city VARCHAR(20) NOT NULL,
MODIFY
    state VARCHAR(20) NOT NULL,
MODIFY
    country VARCHAR(20) NOT NULL,
MODIFY
    postal_code VARCHAR(20) NOT NULL;

ALTER TABLE
    addresses
DROP FOREIGN KEY
    addresses_ibfk_1;

-- Updates to categories table

ALTER TABLE
    categories
MODIFY
    category_name VARCHAR(25) NOT NULL;

-- Updates to customers table

ALTER TABLE
    customers
MODIFY
    first_name VARCHAR(25) NOT NULL,
MODIFY
    last_name VARCHAR(25) NOT NULL;

-- Updates to order_items table

-- Remove the duplicate/conflicting Foreign Keys
ALTER TABLE 
    order_items 
DROP FOREIGN KEY order_items_ibfk_1,
DROP FOREIGN KEY order_items_ibfk_2;

-- Remove the duplicate Check Constraints
ALTER TABLE 
    order_items 
DROP CHECK order_items_chk_2,
DROP CHECK order_items_chk_3,
DROP CHECK order_items_chk_4,
DROP CHECK order_items_chk_5;

--Updates to the orders table

ALTER TABLE
    orders
DROP FOREIGN KEY
    orders_ibfk_1,
DROP CHECK
    orders_chk_2;

-- Updates to the payments table

ALTER TABLE
    payments
DROP FOREIGN KEY
    payments_ibfk_1,
DROP CHECK
    payments_chk_2;

-- Updates to the products table

ALTER TABLE
    products
DROP FOREIGN KEY
    products_ibfk_1,
DROP FOREIGN KEY
    products_ibfk_2,
DROP CHECK
    products_chk_3,
DROP CHECK
    products_chk_4;

-- No Updates to the suppliers table

SHOW CREATE TABLE addresses;
SHOW CREATE TABLE categories;
SHOW CREATE TABLE customers;
SHOW CREATE TABLE order_items;
SHOW CREATE TABLE orders;
SHOW CREATE TABLE payments;
SHOW CREATE TABLE products;
SHOW CREATE TABLE suppliers; 