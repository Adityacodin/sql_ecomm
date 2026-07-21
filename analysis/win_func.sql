use ecomm_db

-- latest order per customer.

SELECT * FROM (
SELECT 
c.customer_id,
c.first_name,
c.last_name,
o.order_id,
o.orderdate,
ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.orderdate DESC) as order_num
FROM orders o
JOIN customers c on o.customer_id  = c.customer_id
) as order_info
WHERE order_num = 1;


-- Top-selling product in each category

SELECT 
p.product_id,
p.product_name,
c.category_name,
COUNT(oi.product_id)
ROW_NUMBER() OVER (PARTITION BY c.category_id ORDER BY  )
from products p
JOIN categories c ON p.category_id = c.category_id;

SELECT * from (
	SELECT 
		p.product_id,
		p.product_name,
		c.category_id,
		c.category_name,
		SUM(oi.quantity) as quantity,
		ROW_NUMBER() OVER (PARTITION BY c.category_id ORDER BY quantity DESC) as row_num
	FROM products p 
	JOIN order_items oi ON p.product_id = oi.product_id
	JOIN orders o ON oi.order_id = o.order_id
	JOIN payments py ON o.order_id = py.order_id
	JOIN categories c ON p.category_id = c.category_id
	WHERE py.payment_status = 'paid'
	GROUP BY p.product_id,p.product_name,c.category_id, c.category_name
) as sq1
where row_num=1;


-- Running monthly revenue
SELECT
	concat(sq1.month,' ',sq1.year) as MONTH,
	sq1.revenue,
	SUM(revenue) OVER(ORDER BY sq1.year asc, month_num asc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as runnning_total_revenue
FROM (
	SELECT 
	    MONTH(payment_date) as month_num,
		MONTHNAME(payment_date) as month,
		YEAR(payment_date) as year,
		sum(amount) as revenue
	from payments
	where payment_status = 'paid'
	GROUP BY DATE_FORMAT(payment_date,"%Y-%m")
) as sq1; 

-- rank customers by lifetime spending
SELECT *,
	RANK() OVER(order by sq1.total_spent_on_orders DESC) AS `rank`
FROM (
	SELECT 
		c.customer_id,
	CONCAT(c.first_name,' ',c.last_name) AS customer_name,
	SUM(total_amount) as total_spent_on_orders
	FROM
	customers c
	JOIN orders o ON c.customer_id = o.customer_id 
	JOIN payments p ON o.order_id = p.order_id
	WHERE p.payment_status = 'paid'
	GROUP BY c.customer_id, customer_name
) as sq1;



