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
)
SELECT
    *,
	LAG(revenue,1) OVER(ORDER BY month_year) as prev_month 
FROM monthly_revenue;
	
	
-- compare product sales with previous ones
with product_wise_monthly_revenue as 
( 
Select 
	DATE_FORMAT(o.orderdate,"%Y-%m") as month_year,
	p.product_id,p.product_name,
	p.category_id,sum(oi.quantity) as quantity,sum(oi.quantity * oi.price_per_unit) as product_revenue 
From products p 
JOIN order_items oi ON p.product_id = oi.product_id 
JOIN orders o ON oi.order_id = o.order_id 
JOIN payments py ON o.order_id = py.order_id 
WHERE py.payment_status = 'paid' 
GROUP BY month_year,p.product_id ),
lag_window_func as (
select *, 
lag(quantity,1) over(partition by product_id order by month_year )as prev_month_quantity, 
lag(product_revenue,1) over(partition by product_id order by month_year )as prev_month_revenue 
from product_wise_monthly_revenue
)
SELECT * FROM lag_window_func where product_revenue < prev_month_revenue;


-- each customer's order along with next order UPDATE e
WITH customer_order_info AS (
	SELECT 
		c.customer_id, 
		concat(c.first_name,' ',c.last_name) as customer_name,
		o.order_id,
		o.orderdate
	FROM orders o
	JOIN customers c ON o.customer_id = c.customer_id
),
lead_window as(
	SELECT 
		*, 
		LEAD(orderdate,1) OVER(partition by customer_id ORDER BY orderdate) as next_order_date
	FROM customer_order_info 
)
	SELECT 
		*,
		DATEDIFF(next_order_date,orderdate) as days_to_next_order
	FROM lead_window;
	
	

-- every customers order amount compared to their first order
with cust_order_info as (
	SELECT 
		c.customer_id,
		concat(c.first_name,' ',c.last_name) as customer_name,
		o.order_id,
		o.orderdate,
		o.total_amount
	FROM orders o
	JOIN customers c ON o.customer_id = c.customer_id
	GROUP BY o.order_id
),
f_val_func as (
SELECT *,FIRST_VALUE(total_amount) OVER(PARTITION BY customer_id order by orderdate) as first_order_amount
FROM cust_order_info
)
SELECT *,
	total_amount - first_order_amount as amount_difference
FROM f_val_func;

 
-- complete opposite using last_value()
with cust_order_info as (
	SELECT 
		c.customer_id,
		concat(c.first_name,' ',c.last_name) as customer_name,
		o.order_id,
		o.orderdate,
		o.total_amount
	FROM orders o
	JOIN customers c ON o.customer_id = c.customer_id
	GROUP BY o.order_id
),
f_val_func as (
SELECT *,LAST_VALUE(total_amount) OVER(PARTITION BY customer_id order by orderdate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as recent_order_amount
FROM cust_order_info
)
SELECT *,
	total_amount - recent_order_amount as amount_difference
FROM f_val_func;


-- each customers order amount compared with their average
with cust_order_info as (
	SELECT 
		c.customer_id,
		concat(c.first_name,' ',c.last_name) as customer_name,
		o.order_id,
		o.orderdate,
		o.total_amount
	FROM orders o
	JOIN customers c ON o.customer_id = c.customer_id
	GROUP BY o.order_id
)
SELECT 
	customer_name,
	order_id,
	orderdate,
	total_amount,
	ROUND(AVG(total_amount) OVER(partition by customer_id),2) as customer_average
FROM cust_order_info;

WITH prod_cat_info AS (
	SELECT 
		p.product_id,
		p.product_name,
		p.price,
		c.category_id
	FROM products p 
	JOIN categories c ON p.category_id  = c.category_id
	GROUP BY p.product_id,p.product_name
)
SELECT 
	product_id,
	product_name,
	price,
	ROUND(AVG(price) OVER(PARTITION BY category_id),2) as avg_product_price_wrt_category
FROM prod_cat_info;


-- each order amount as a percentage of the customer's total spending
with cust_order_info as (
	SELECT 
		c.customer_id,
		concat(c.first_name,' ',c.last_name) as customer_name,
		o.order_id,
		o.total_amount
	FROM orders o
	JOIN customers c ON o.customer_id = c.customer_id
	GROUP BY o.order_id	
)
SELECT *,
	ROUND(total_amount*100.0 / SUM(total_amount) OVER(PARTITION BY customer_id),2) as percentage_contribution_to_total_spent
FROM cust_order_info;
	

-- each month's revenue as a percentage of the total company revenue.
WITH monthly_revenue as (
	SELECT 
			MONTHNAME(payment_date) as month,
			DATE_FORMAT(payment_date,"%Y-%m") as month_year,
			sum(amount) as revenue
	FROM payments
	WHERE payment_status = 'paid'
	GROUP BY DATE_FORMAT(payment_date,"%Y-%m")
)
SELECT *,
ROUND(revenue * 100.0 / SUM(revenue) OVER(),2) as percentage
FROM monthly_revenue 
ORDER BY month_year ASC;


-- customers whose latest order is above their own average order value
with cust_order_info as (
	SELECT 
		c.customer_id,
		concat(c.first_name,' ',c.last_name) as customer_name,
		o.order_id,
		o.orderdate,
		o.total_amount
	FROM orders o
	JOIN customers c ON o.customer_id = c.customer_id
),
row_avg_info as (
	SELECT
		order_id,
		orderdate,
		customer_id,
		customer_name,
		total_amount,
		ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY orderdate DESC) as row_num,
		ROUND(AVG(total_amount) OVER(PARTITION BY customer_id),2) as avg_order_value	
	FROM cust_order_info
)
SELECT
	order_id,
	orderdate,
	customer_id,
	customer_name,
	total_amount,
	avg_order_value
FROM row_avg_info 
WHERE row_num = 1 AND total_amount > avg_order_value; 

-- sales information
WITH prod_info AS (
	SELECT 
		p.product_id,
		p.product_name,
		SUM(oi.price_per_unit * oi.quantity) as revenue,
		SUM(oi.quantity) as units_sold
	FROM products p 
	JOIN order_items oi ON p.product_id = oi.product_id
	JOIN orders o ON oi.order_id = o.order_id
	JOIN payments py ON o.order_id = py.order_id
	WHERE py.payment_status = 'paid'
	GROUP BY p.product_id,p.product_name
)
SELECT *,
	RANK() OVER(ORDER BY revenue DESC) as revenue_rank,
	SUM(revenue) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_revenue
FROM prod_info;




	
