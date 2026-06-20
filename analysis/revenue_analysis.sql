USE ecomm_db;
-- revenue

-- by month
SELECT MONTHNAME(payment_date) as `Month`,SUM(amount) as `Revenue`
FROM payments
WHERE payment_status = 'paid'
GROUP BY `Month`
ORDER BY MONTH(payment_date);

-- by category
-- payments - order_items - products - category --> wrong query as i ignored order_items table's
SELECT c.category_name as `Category`,SUM(p.amount) AS `Revenue`
FROM payments p
JOIN orders o ON p.order_id = o.order_id 
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products pr ON oi.product_id = pr.product_id
JOIN categories c ON pr.category_id = c.category_id
WHERE payment_status = 'paid'
GROUP BY c.category_id
ORDER BY `Revenue` DESC;

SELECT c.category_name,sum(oi.price_per_unit * oi.quantity) as REVENUE from order_items oi 
join orders o on oi.order_id = o.order_id 
join payments p on o.order_id = p.order_id
join products pr ON oi.product_id = pr.product_id
join categories c on pr.category_id = c.category_id
WHERE p.payment_status = 'paid'
GROUP BY category_name;

-- revenue by city
SELECT a.city, sum(p.amount) as revenue
from payments p 
JOIN orders o ON p.order_id = o.order_id 
JOIN customers c on o.customer_id = c.customer_id
JOIN addresses a on c.customer_id = a.customer_id
WHERE p.payment_status = 'paid'
GROUP BY  a.city;

-- revenue by state
SELECT a.state, sum(p.amount) as revenue
from payments p 
JOIN orders o ON p.order_id = o.order_id 
JOIN customers c on o.customer_id = c.customer_id
JOIN addresses a on c.customer_id = a.customer_id
WHERE p.payment_status = 'paid'
GROUP BY  a.state;
