-- Customers

-- top 10 by spend
select c.first_name,c.last_name,sum(p.amount) as `SPEND`
from payments p
JOIN orders o ON p.order_id = o.order_id 
JOIN customers c ON o.customer_id = c.customer_id
WHERE p.payment_status = 'paid'
GROUP BY c.first_name,c.last_name
ORDER BY SPEND DESC limit 10;


-- customers with most orders
select c.first_name,c.last_name, COUNT(o.order_id) as total_orders
from orders o
JOIN customers c on o.customer_id = c.customer_id
GROUP BY c.first_name,c.last_name
ORDER BY total_orders DESC LIMIT 10;

-- avg customer spend
select SUM(p.amount)/COUNT(DISTINCT c.customer_id) as avg_customer_spend
from payments p
JOIN orders o ON p.order_id = o.order_id
Join customers c on o.customer_id = c.customer_id
WHERE p.payment_status = 'paid';

-- customer who never ordered
select c.customer_id,c.first_name,c.last_name
from customers c
WHERE c.customer_id NOT IN (SELECT o.customer_id from orders o); 
