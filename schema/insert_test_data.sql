use ecomm_db;

INSERT INTO customers (customer_id, first_name, last_name, email, phone, created_at) VALUES
(100, 'Aarav', 'Sharma', 'aarav.sharma@gmail.com', '9876543210', '2026-01-10 09:15:00'),
(101, 'Priya', 'Mehta', 'priya.mehta@gmail.com', '9823456712', '2026-01-14 11:20:00'),
(102, 'Rohan', 'Patil', 'rohan.patil@gmail.com', '9988776655', '2026-02-01 14:05:00'),
(103, 'Sneha', 'Kulkarni', 'sneha.kulkarni@gmail.com', '9765432108', '2026-02-11 16:30:00'),
(104, 'Vikram', 'Nair', 'vikram.nair@gmail.com', '9898989898', '2026-03-05 10:45:00');

desc addresses;
alter table addresses add column address_line1 varchar(100) not null after customer_id; 
INSERT INTO addresses (address_id, customer_id, address_line1, city, state, postal_code, country) VALUES
(100, 100, '12 Palm Residency, Andheri East', 'Mumbai', 'Maharashtra', 'India', '400069'),
(101, 101, '44 Lake View Apartments', 'Pune', 'Maharashtra', 'India', '411038'),
(102, 102, '88 Green Park Colony', 'Nagpur', 'Maharashtra', 'India', '440010'),
(103, 103, '22 Sapphire Heights', 'Bengaluru', 'Karnataka', 'India', '560076'),
(104, 104, '9 Marine Residency', 'Kochi', 'Kerala', 'India', '682020')

desc categories;
INSERT INTO categories (category_id, category_name) VALUES
(100, 'Electronics'),
(101, 'Clothing'),
(102, 'Home & Kitchen'),
(103, 'Books'),
(104, 'Accessories');

desc suppliers;
desc products;
desc orders;
desc order_items;
desc payments;
show tables;

INSERT INTO suppliers (supplier_id, supplier_name, contact_email) VALUES
(100, 'TechNova India Pvt Ltd', 'sales@technovaindia.com'),
(101, 'UrbanStyle Retailers', 'support@urbanstyle.in'),
(102, 'KitchenKart Supplies', 'contact@kitchenkart.in'),
(103, 'BookVerse Distributors', 'hello@bookverse.in'),
(104, 'AccessoryHub Traders', 'sales@accessoryhub.in');

INSERT INTO products (product_id, category_id, supplier_id, product_name, price, stock_quantity, created_at) VALUES
(100, 100, 100, 'Redmi Note 13 5G', 16999.00, 45, '2026-01-05 09:00:00'),
(101, 100, 100, 'Boat Rockerz 450', 1499.00, 120, '2026-01-05 09:20:00'),
(102, 101, 101, 'Men Cotton Hoodie', 1199.00, 80, '2026-01-06 10:00:00'),
(103, 101, 101, 'Women Casual Kurti', 899.00, 65, '2026-01-06 10:20:00'),
(104, 102, 102, 'Prestige Mixer Grinder', 3499.00, 35, '2026-01-07 11:00:00'),
(105, 102, 102, 'Non-Stick Cookware Set', 2599.00, 40, '2026-01-07 11:15:00'),
(106, 103, 103, 'Atomic Habits', 499.00, 100, '2026-01-08 12:00:00'),
(107, 103, 103, 'Introduction to SQL', 799.00, 50, '2026-01-08 12:15:00'),
(108, 104, 104, 'Noise Smartwatch', 2999.00, 55, '2026-01-09 13:00:00'),
(109, 104, 104, 'Portronics Power Bank', 1799.00, 70, '2026-01-09 13:20:00');

INSERT INTO orders (order_id, customer_id, orderdate, status, total_amount) VALUES
(100, 100, '2026-03-01 10:30:00', 'delivered', 18498.00),
(101, 101, '2026-03-02 12:15:00', 'shipped', 4797.00),
(102, 102, '2026-03-03 09:45:00', 'delivered', 1698.00),
(103, 103, '2026-03-04 14:10:00', 'pending', 2999.00),
(104, 104, '2026-03-05 16:40:00', 'cancelled', 16999.00),
(105, 100, '2026-03-06 11:25:00', 'delivered', 4397.00),
(106, 101, '2026-03-07 18:00:00', 'returned', 3499.00),
(107, 102, '2026-03-08 13:50:00', 'delivered', 1998.00),
(108, 103, '2026-03-09 15:20:00', 'delivered', 4398.00),
(109, 104, '2026-03-10 17:45:00', 'shipped', 2098.00);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, price_per_unit) VALUES
(100, 100, 100, 1, 16999.00),
(101, 100, 101, 1, 1499.00),
(102, 101, 104, 1, 3499.00),
(103, 101, 106, 1, 499.00),
(104, 101, 107, 1, 799.00),
(105, 102, 102, 1, 1199.00),
(106, 102, 106, 1, 499.00),
(107, 103, 108, 1, 2999.00),
(108, 104, 100, 1, 16999.00),
(109, 105, 108, 1, 2999.00),
(110, 105, 103, 1, 899.00),
(111, 105, 106, 1, 499.00),
(112, 106, 104, 1, 3499.00),
(113, 107, 101, 1, 1499.00),
(114, 107, 107, 1, 799.00),
(115, 108, 105, 1, 2599.00),
(116, 108, 109, 1, 1799.00),
(117, 109, 102, 1, 1199.00),
(118, 109, 103, 1, 899.00);

INSERT INTO payments (payment_id, order_id, payment_method, payment_status, payment_date, amount) VALUES
(100, 100, 'upi', 'paid', '2026-03-01 10:45:00', 18498.00),
(101, 101, 'card_credit', 'paid', '2026-03-02 12:30:00', 4797.00),
(102, 102, 'wallet_phonepe', 'paid', '2026-03-03 10:05:00', 1698.00),
(103, 103, 'upi', 'pending', '2026-03-04 14:25:00', 2999.00),
(104, 104, 'card_credit', 'refunded', '2026-03-05 17:00:00', 16999.00),
(105, 105, 'cod', 'paid', '2026-03-08 09:00:00', 4397.00),
(106, 106, 'upi', 'refunded', '2026-03-10 12:00:00', 3499.00),
(107, 107, 'wallet_phonepe', 'paid', '2026-03-08 14:10:00', 1998.00),
(108, 108, 'card_credit', 'paid', '2026-03-09 15:40:00', 4398.00),
(109, 109, 'cod', 'pending', '2026-03-10 18:10:00', 2098.00);
