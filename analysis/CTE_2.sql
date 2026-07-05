USE ecomm_db;

-- Create one CTE for customer spending and another for average spending. List customers whose spending is above average.
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

-- Create one CTE for product sales and another for category sales. Find the highest-selling product within each category.
WITH CTE_product_sales AS (

SELECT p.product_id,p.product_name,c.category_id,SUM(oi.quantity)as product_sales
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN order_items oi ON p.product_id = oi.product_id 
JOIN orders o ON oi.order_id = o.order_id
GROUP BY p.product_id,p.product_name

), 
CTE_category_sales AS (

SELECT c.category_id,c.category_name,SUM(oi.quantity)as category_sales
FROM categories c
JOIN products p ON c.category_id = p.category_id 
JOIN order_items oi ON p.product_id = oi.product_id 
JOIN orders o ON oi.order_id = o.order_id
GROUP BY c.category_id,c.category_name

)
SELECT *
FROM CTE_product_sales cp
JOIN CTE_category_sales cc ON cp.category_id = cc.category_id;

-- Create one CTE for orders and another for payments. Show orders that were placed but never successfully paid.

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

-- Create one CTE containing all refunded payments and another containing paid payments. Calculate the refund percentage.
WITH CTE_payments_refunded AS (
	SELECT COUNT(p.payment_id) as num_of_refunded_orders FROM payments p WHERE payment_status = 'refunded'
), 
CTE_payments_paid AS (
	SELECT COUNT(p.payment_id) AS num_of_paid_orders FROM payments p WHERE payment_status = 'paid'
)
SELECT ROUND(pr.num_of_refunded_orders/pp.num_of_paid_orders*100,2) AS refund_percentage
FROM CTE_payments_refunded pr
CROSS JOIN CTE_payments_paid pp;
-- modern sql style to in table since each table has a single column

-- Create one CTE containing supplier revenue and another containing average supplier revenue. Show suppliers performing above average.
WITH CTE_supplier_revenue AS (
	SELECT s.supplier_id,s.supplier_name,SUM(oi.quantity * oi.price_per_unit) as supplier_revenue
	FROM order_items oi
	JOIN orders o ON oi.order_id = o.order_id
	JOIN payments py ON o.order_id = py.order_id
	JOIN products p  ON oi.product_id = p.product_id
	JOIN suppliers s ON p.supplier_id = s.supplier_id
	WHERE py.payment_status = 'paid'
	GROUP BY s.supplier_id,s.supplier_name
),
CTE_avg_supplier_revenue AS (
	SELECT avg(supplier_revenue) as avg_supplier_revenue
	FROM CTE_supplier_revenue
)
SELECT *
FROM CTE_supplier_revenue 
WHERE supplier_revenue > (SELECT avg_supplier_revenue from CTE_avg_supplier_revenue);



