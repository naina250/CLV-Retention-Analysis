 /* CLV (Customer Lifetime Value) CALCULATION 
    CLV = AVG ORDER VALUE * PURCHACE FREQUENCY * CUSTOMER LIFESPAN 
*/
SELECT * FROM ecommerce_transactions;

WITH clv_metrics AS (
	SELECT customer_id,
		SUM(revenue) AS clv
        FROM ecommerce_transactions
    GROUP BY customer_id
),
ranked_clv AS (
	SELECT customer_id, clv,
		NTILE(3) OVER(ORDER BY clv DESC) AS clv_group
	FROM clv_metrics
)
SELECT 
CASE 
	WHEN clv_group = 1 THEN "High Value"
	WHEN clv_group = 2 THEN "Medium Value"
	ELSE "Low Value"
END AS CLV_Segment,
	COUNT(*) AS Customers,
    SUM(clv) AS total_revenue,
    AVG(clv) AS avg_clv
FROM ranked_clv
GROUP BY CLV_Segment
ORDER BY total_revenue DESC;
