```sql
-- Project: Customer Segmentation & RFM Analysis
-- Database: customer_analytics
-- Tool: PostgreSQL

-- 1. Create retail sales table

CREATE TABLE IF NOT EXISTS retail_sales (
    invoice_no VARCHAR(20),
    stock_code VARCHAR(20),
    description TEXT,
    quantity INTEGER,
    invoice_date TIMESTAMP,
    unit_price NUMERIC(12,2),
    customer_id BIGINT,
    country VARCHAR(100)
);

-- 2. Check table structure and data

SELECT *
FROM retail_sales
LIMIT 10;

-- 3. Check total records

SELECT COUNT(*) AS total_records
FROM retail_sales;

-- 4. Check missing customer IDs

SELECT COUNT(*) AS missing_customer_ids
FROM retail_sales
WHERE customer_id IS NULL;

-- 5. Check duplicate records

SELECT
    invoice_no,
    stock_code,
    customer_id,
    COUNT(*) AS duplicate_count
FROM retail_sales
GROUP BY invoice_no, stock_code, customer_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- 6. Calculate total revenue

SELECT
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM retail_sales
WHERE quantity > 0
  AND unit_price > 0
  AND invoice_no NOT LIKE 'C%';

-- 7. Calculate total orders

SELECT
    COUNT(DISTINCT invoice_no) AS total_orders
FROM retail_sales
WHERE invoice_no NOT LIKE 'C%';

-- 8. Calculate total customers

SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales
WHERE customer_id IS NOT NULL;

-- 9. Monthly revenue analysis

SELECT
    DATE_TRUNC('month', invoice_date)::DATE AS sales_month,
    ROUND(SUM(quantity * unit_price), 2) AS monthly_revenue
FROM retail_sales
WHERE quantity > 0
  AND unit_price > 0
  AND invoice_no NOT LIKE 'C%'
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY sales_month;

-- 10. Country-wise revenue analysis

SELECT
    country,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM retail_sales
WHERE quantity > 0
  AND unit_price > 0
  AND invoice_no NOT LIKE 'C%'
GROUP BY country
ORDER BY total_revenue DESC;

-- 11. Top 10 products by revenue

SELECT
    stock_code,
    description,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM retail_sales
WHERE quantity > 0
  AND unit_price > 0
  AND invoice_no NOT LIKE 'C%'
GROUP BY stock_code, description
ORDER BY total_revenue DESC
LIMIT 10;

-- 12. Customer-wise revenue analysis

SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(quantity * unit_price), 2) AS total_spending
FROM retail_sales
WHERE customer_id IS NOT NULL
  AND quantity > 0
  AND unit_price > 0
  AND invoice_no NOT LIKE 'C%'
GROUP BY customer_id
ORDER BY total_spending DESC
LIMIT 10;
```
