 /* CUSTOMER METRICS */
 
SELECT * FROM ecommerce_transactions;

-- TOTAL REVENUE
SELECT SUM(revenue) AS total_revenue 
FROM ecommerce_transactions;

-- TOTAL ORDERS
SELECT COUNT(order_id) AS total_orders 
FROM ecommerce_transactions;

-- TOTAL CUSTOMERS
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM ecommerce_transactions;

-- AVG CLV
SELECT AVG(total_customer_revenue) AS avg_clv 
FROM ( 
	SELECT 
		customer_id, 
		SUM(revenue) AS total_customer_revenue 
	FROM ecommerce_transactions 
	GROUP BY customer_id
) AS customer_revenue;

-- REPEAT PURCHASE CUSTOMER
SELECT 
	COUNT(DISTINCT customer_id) AS customer,
    (COUNT(DISTINCT CASE WHEN order_count > 1 THEN customer_id END)/COUNT(*)) * 100 AS repeat_purchase_rate
FROM (
	SELECT 
		customer_id,
		COUNT(order_id) AS order_count
	FROM ecommerce_transactions
	GROUP BY customer_id
) AS repea;


