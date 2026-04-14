/*==============================================================
  Script: 07_change_over_time_analysis.sql
  Purpose: Analyze monthly trends in sales, customers, and quantity
  Notes:
    - Helps understand seasonality and business performance over time
==============================================================*/


-------------------------------
-- Monthly sales, customers, and quantity trends
-------------------------------
SELECT
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY order_month;