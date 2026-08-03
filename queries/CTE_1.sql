  GNU nano 7.2                        CTE_1.sql                                 
SELECT p.product_id,p.product_name, SUM(oi.quantity) as units_sold
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o on oi.order_id = o.order_id
JOIN payments py ON o.order_id = py.order_id
WHERE py.payment_status = 'paid'
GROUP BY p.product_id,p.product_name
)
SELECT * FROM total_units_sold ORDER BY units_sold DESC LIMIT 10;


-- Compute monthly revenue, then display only months where revenue exceeded the>
WITH monthly_revenue AS (
SELECT MONTHNAME(payment_date) as month ,SUM(amount) as revenue
FROM payments
WHERE payment_status = 'paid'
GROUP BY month,year
)
SELECT * FROM monthly_revenue WHERE revenue > (SELECT AVG(revenue) FROM monthly>

 
