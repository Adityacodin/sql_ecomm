-- =====================================================
-- SALES REPORTS
-- =====================================================

-- Monthly Revenue

SELECT MONTHNAME(payment_date) as `Month`,SUM(amount) as `Revenue`
FROM payments
WHERE payment_status = 'paid'
GROUP BY `Month`
ORDER BY MONTH(payment_date);

-- Running Monthly Revenue

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

-- Revenue by Category

SELECT c.category_name,sum(oi.price_per_unit * oi.quantity) as REVENUE from order_items oi 
join orders o on oi.order_id = o.order_id 
join payments p on o.order_id = p.order_id
join products pr ON oi.product_id = pr.product_id
join categories c on pr.category_id = c.category_id
WHERE p.payment_status = 'paid'
GROUP BY category_name;

-- Sales Leaderboard

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


-- =====================================================
-- CUSTOMER REPORTS
-- =====================================================

-- Top Customers by Spending

select c.first_name,c.last_name,sum(p.amount) as `SPEND`
from payments p
JOIN orders o ON p.order_id = o.order_id 
JOIN customers c ON o.customer_id = c.customer_id
WHERE p.payment_status = 'paid'
GROUP BY c.first_name,c.last_name
ORDER BY SPEND DESC limit 10;

-- Customer Lifetime Spending

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

-- Average Customer Spend

select SUM(p.amount)/COUNT(DISTINCT c.customer_id) as avg_customer_spend
from payments p
JOIN orders o ON p.order_id = o.order_id
Join customers c on o.customer_id = c.customer_id
WHERE p.payment_status = 'paid';

-- Customers Above Average Spending

WITH customer_spend AS (
SELECT c.customer_id,c.first_name,c.last_name,SUM(p.amount) as spend
from payments p
JOIN orders o ON p.order_id = o.order_id 
JOIN customers c ON o.customer_id = c.customer_id
WHERE p.payment_status = 'paid'
GROUP BY c.customer_id
),
avg_customer_spend AS (
SELECT SUM(p.amount)/COUNT(DISTINCT c.customer_id) as average_spend
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE p.payment_status = 'paid'
)
SELECT * FROM customer_spend
WHERE spend > (SELECT average_spend from avg_customer_spend);

-- Latest Order per Customer

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


-- =====================================================
-- PRODUCT REPORTS
-- =====================================================

-- Top Selling Products

select p.product_id,p.product_name, SUM(oi.quantity) as units_sold
from order_items oi 
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id,p.product_name
ORDER BY units_sold DESC LIMIT 5;

-- Top Product in Each Category

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

-- Products Never Purchased

select p.product_id,p.product_name
from products p
left join order_items oi on p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Products with Monthly Revenue Trend

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


-- =====================================================
-- INVENTORY REPORTS
-- =====================================================

-- No inventory remaining query found in the repository.


-- =====================================================
-- PAYMENT REPORTS
-- =====================================================

-- Payment Method Distribution

select p.payment_method, COUNT(p.payment_id) as times_used
from payments p
GROUP BY p.payment_method
ORDER BY times_used DESC;

-- Refund Percentage

WITH CTE_payments_refunded AS (
	SELECT COUNT(p.payment_id) as num_of_refunded_orders FROM payments p WHERE payment_status = 'refunded'
), 
CTE_payments_paid AS (
	SELECT COUNT(p.payment_id) AS num_of_paid_orders FROM payments p WHERE payment_status = 'paid'
)
SELECT ROUND(pr.num_of_refunded_orders/pp.num_of_paid_orders*100,2) AS refund_percentage
FROM CTE_payments_refunded pr
CROSS JOIN CTE_payments_paid pp;

-- Orders Without Successful Payments

WITH CTE_orders AS (
	SELECT o.order_id, o.total_amount,o.status,o.customer_id,o.orderdate from orders o
),
CTE_succesful_payments AS (
	SELECT p.payment_id,p.payment_method,p.payment_date,p.payment_status,p.order_id
	FROM payments p
	WHERE p.payment_status = 'paid'
)
SELECT o.order_id,o.orderdate,o.status,o.total_amount
FROM CTE_orders o
LEFT JOIN CTE_succesful_payments sp ON o.order_id = sp.order_id 
WHERE sp.payment_id IS NULL;


-- =====================================================
-- SUPPLIER REPORTS
-- =====================================================

-- Revenue by Supplier

select s.supplier_id,s.supplier_name, sum(oi.quantity * oi.price_per_unit) as revenue
from order_items oi
JOIN orders o on oi.order_id = o.order_id
join payments pr ON o.order_id = pr.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
where pr.payment_status = 'paid'
GROUP BY s.supplier_id,s.supplier_name
ORDER BY revenue DESC;
