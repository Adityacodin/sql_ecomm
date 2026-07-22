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


 
-- Rank categories by total revenue.
SELECT *,
	RANK() OVER(ORDER BY revenue DESC) as revenue_rank
FROM (
	SELECT c.category_id,c.category_name, SUM(oi.price_per_unit * oi.quantity) as revenue
	from order_items oi
	JOIN products p ON oi.product_id = p.product_id
	JOIN categories c ON p.category_id = c.category_id
	JOIN orders o ON oi.order_id = o.order_id
	JOIN payments py ON o.order_id = py.order_id
	WHERE py.payment_status = 'paid'
	GROUP BY c.category_id,c.category_name
) as sq1;

-- top 3 selling product each category 
with product_revenue as (
	SELECT p.product_id,p.product_name,c.category_id,c.category_name, SUM(oi.price_per_unit * oi.quantity) as revenue
	from order_items oi
	JOIN products p ON oi.product_id = p.product_id
	JOIN categories c ON p.category_id = c.category_id
	JOIN orders o ON oi.order_id = o.order_id
	JOIN payments py ON o.order_id = py.order_id
	WHERE py.payment_status = 'paid'
	GROUP BY p.product_id,p.product_name,c.category_id,c.category_name
),
ranked_products as (
	SELECT *,	
		DENSE_RANK() OVER(PARTITION BY category_id ORDER BY revenue) as rank
	FROM product_revenue
)
SELECT * FROM
ranked_products
WHERE rank <= 3;

-- top 2 customers in each city based on their spend
WITH customers_spend as (
SELECT  a.city,
		c.customer_id,
	CONCAT(c.first_name,' ',c.last_name) AS customer_name,
	SUM(total_amount) as total_spent_on_orders
	FROM
	customers c
	JOIN orders o ON c.customer_id = o.customer_id 
	JOIN payments p ON o.order_id = p.order_id
	JOIN addresses a ON c.customer_id  = a.customer_id 
	WHERE p.payment_status = 'paid'
	GROUP BY c.customer_id
), customers_ranked as (
	SELECT *,
		DENSE_RANK() OVER(partition by city order by total_spent_on_orders DESC) as ranked
	FROM customers_spend 
)
SELECT *
FROM customers_ranked 
WHERE ranked<=2;


-- comparing each months revenue with previous month's
WITH monthly_revenue as (
	SELECT 
			MONTHNAME(payment_date) as month,
			DATE_FORMAT(payment_date,"%Y-%m") as month_year,
			sum(amount) as revenue
	FROM payments
	WHERE payment_status = 'paid'
	GROUP BY DATE_FORMAT(payment_date,"%Y-%m")
),
SELECT
	LAG(revenue,1,1,0) OVER(PARTITION BY month_year) as prev_month 
FROM monthly_revenue;
	
