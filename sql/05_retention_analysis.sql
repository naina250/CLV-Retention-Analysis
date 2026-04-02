 /* RETENTION ANALYSIS 
 GOAL: Do customers come back after their first purchase?  */

-- identify first purchase (cohort creation)
WITH first_purchase AS (
	SELECT 
		customer_id,
        MIN(order_date) AS first_purchase_date,
        DATE_FORMAT(MIN(order_date), '%Y-%m-01') AS cohort_month
    FROM ecommerce_transactions
    GROUP BY customer_id
),
-- join cohort to every transactions
cohort_transactions AS (
	SELECT 
		e.customer_id,
        e.order_date,
        f.cohort_month,
		DATE_FORMAT(e.order_date, '%Y-%m-01') AS order_month
	FROM ecommerce_transactions e
    JOIN first_purchase f
    ON e.customer_id = f.customer_id
),
-- calculate month difference
month_diff AS (
	SELECT 
		customer_id,
        cohort_month,
        order_month,
        TIMESTAMPDIFF(MONTH, cohort_month, order_month) AS month_number
    FROM cohort_transactions
),
-- select unique customers
unique_customer_month AS (
	SELECT DISTINCT
		customer_id, cohort_month, month_number
	FROM month_diff
),
-- count active customers per month
cohorts_count AS (
	SELECT 
		cohort_month,
        month_number,
        COUNT(customer_id) AS customer_count
    FROM unique_customer_month
    GROUP BY cohort_month, month_number
),
-- get cohort size 
cohorts_size AS (
	SELECT 
		cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_size
        FROM month_diff
        WHERE month_number = 0
        GROUP BY cohort_month
)
SELECT 
	c.cohort_month,
    c.month_number,
    c.customer_count,
    s.cohort_size,
    ROUND((c.customer_count / s.cohort_size) * 100, 2) AS retention_rate
FROM cohorts_count c
JOIN cohorts_size s
ON c.cohort_month = s.cohort_month
ORDER BY cohort_month, month_number;
