/*==============================================================
  Script: 05_magnitude_analysis.sql
  Purpose: Analyze magnitude metrics across customers, products, and revenue
  Notes:
    - Includes customer distribution, product distribution, cost, and revenue KPIs
==============================================================*/


-------------------------------
-- 1) Total customers by country
-------------------------------
SELECT 
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;


-------------------------------
-- 2) Total customers by gender
-------------------------------
SELECT 
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;


-------------------------------
-- 3) Total products by category
-------------------------------
SELECT 
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;


-------------------------------
-- 4) Average cost per category
-------------------------------
SELECT 
    category,
    AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC;


-------------------------------
-- 5) Total revenue by category
-------------------------------
SELECT 
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;


-------------------------------
-- 6) Total revenue by customer
-------------------------------
SELECT 
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
-- 7) Distribution of sold items across countries
-------------------------------
SELECT 
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c 
    ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;
