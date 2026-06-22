-- category

-- best performing category
SELECT c.category_name, sum(oi.quantity * oi.price_per_unit) as revenue
from order_items oi
join orders o ON oi.order_id = o.order_id 
join payments p on o.order_id = p.order_id
join products pr on oi.product_id = pr.product_id
join categories c on pr.category_id = c.category_id
where p.payment_status = 'paid'
GROUP BY c.category_name
ORDER BY revenue DESC LIMIT 1;

-- least performing category
SELECT c.category_name, sum(oi.quantity * oi.price_per_unit) as revenue
from order_items oi
join orders o ON oi.order_id = o.order_id 
join payments p on o.order_id = p.order_id
join products pr on oi.product_id = pr.product_id
join categories c on pr.category_id = c.category_id
where p.payment_status = 'paid'
GROUP BY c.category_name
ORDER BY revenue LIMIT 1;

-- average order value per category
select c.category_id,c.category_name,ROUND(SUM(p.amount)/COUNT(o.order_id),2) as avg_order_value
from payments p
JOIN orders o ON p.order_id = o.order_id
join products pr on o.order_id = pr.product_id
join categories c on pr.category_id = c.category_id
WHERE p.payment_status = 'paid'
GROUP BY c.category_id,c.category_name;
