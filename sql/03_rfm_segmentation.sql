/* RFM (Recency, Frequency, Monetary) SEGMENTATION */

SELECT * FROM ecommerce_transactions;

WITH rfm_calculate AS (
	SELECT customer_id,
		DATEDIFF(CURDATE(), MAX(order_date)) AS recency,
		COUNT(order_id) AS frequency,
		SUM(revenue) AS monetary
	FROM ecommerce_transactions
	GROUP BY customer_id
),
rfm_scores AS (
	SELECT customer_id, recency, frequency, monetary,
		NTILE(5) OVER(ORDER BY recency ASC) AS recency_score,
		NTILE(5) OVER(ORDER BY frequency DESC) AS frequency_score,
		NTILE(5) OVER(ORDER BY monetary DESC) AS monetary_score
	FROM rfm_calculate
),
rfm_segment AS (
	SELECT *,
		CASE 
			WHEN recency_score >=4 AND frequency_score >=4 AND monetary_score >=4 THEN 'Champions'
			WHEN frequency_score >=4 AND monetary_score >=4 THEN 'Loyal Customers'
			WHEN recency_score >=4 AND frequency_score >=3 THEN 'Potential Loyal'
			WHEN recency_score >=4 THEN 'Promising'
			WHEN recency_score =5 AND frequency_score <=2 THEN 'New Customer'
			WHEN recency_score =3 THEN 'Needing Attention'
			WHEN recency_score <=2 AND frequency_score >=4 THEN 'Cannot Lose Them'
			WHEN recency_score <=2 AND frequency_score >=2 THEN 'Customers At Risk'
			WHEN recency_score = 1 THEN 'Lost Customers'
			ELSE 'Others'
		END AS Segment
	FROM rfm_scores
)
SELECT Segment, 
	COUNT(*) AS customers, 
    SUM(monetary) AS revenue
FROM rfm_segment
GROUP BY Segment
ORDER BY revenue DESC;
