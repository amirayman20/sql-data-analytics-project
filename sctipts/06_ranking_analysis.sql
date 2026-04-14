/*==============================================================
  Script: 06_ranking_analysis.sql
  Purpose: Ranking products and customers based on revenue and orders
  Notes:
    - Includes top/worst products and top/low-engagement customers
==============================================================*/


-------------------------------
-- 1) Top 5 products generating highest revenue
-------------------------------
SELECT TOP 5 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;


-------------------------------
-- 2) Alternative solution using ROW_NUMBER()
-------------------------------
SELECT *
FROM (
    SELECT  
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p 
        ON f.product_key = p.product_key
    GROUP BY p.product_name
) t
WHERE rank_products <= 5;


-------------------------------
-- 3) Bottom 5 worst-performing products (lowest revenue)
-------------------------------
SELECT TOP 5 
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;


-------------------------------
-- 4) Top 10 customers generating highest revenue
-------------------------------
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c 
    ON f.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;


-------------------------------
-- 5) Top 3 customers with the fewest orders placed
-------------------------------
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c 
    ON f.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ASC;