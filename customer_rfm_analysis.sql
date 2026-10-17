-- Customer Segmentation & RFM Analysis
-- PostgreSQL

WITH valid_sales AS (
    SELECT
        invoice_no,
        customer_id,
        invoice_date,
        quantity * unit_price AS revenue
    FROM retail_sales
    WHERE customer_id IS NOT NULL
      AND quantity > 0
      AND unit_price > 0
      AND invoice_no NOT LIKE 'C%'
),
rfm AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS frequency,
        ROUND(SUM(revenue), 2) AS monetary,
        MAX(invoice_date)::date AS last_purchase
    FROM valid_sales
    GROUP BY customer_id
),
scored AS (
    SELECT
        *,
        (
            (SELECT MAX(invoice_date)::date + 1 FROM valid_sales)
            - last_purchase
        ) AS recency_days
    FROM rfm
)
SELECT
    customer_id,
    recency_days,
    frequency,
    monetary,
    last_purchase,
    CASE
        WHEN recency_days <= 30 AND frequency >= 10
            THEN 'Loyal Customers'
        WHEN recency_days <= 30
            THEN 'Recent Customers'
        WHEN recency_days > 90 AND frequency >= 3
            THEN 'At Risk'
        ELSE 'Other Customers'
    END AS customer_segment
FROM scored
ORDER BY monetary DESC;
