/*==============================================================
  Script: 04_measures_exploration.sql
  Purpose: Calculate key business measures and generate summary report
  Notes:
    - Includes sales, quantity, pricing, orders, products, and customers KPIs
==============================================================*/


-------------------------------
-- 1) Total Sales
-------------------------------
SELECT 
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;


-------------------------------
-- 2) Total Quantity Sold
-------------------------------
SELECT 
    SUM(quantity) AS total_quantity
FROM gold.fact_sales;


-------------------------------
-- 3) Average Selling Price
-------------------------------
SELECT 
    AVG(price) AS avg_price
FROM gold.fact_sales;


-------------------------------
-- 4) Total Number of Orders
-------------------------------
SELECT 
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;


-------------------------------
-- 5) Total Number of Products
-------------------------------
SELECT 
    COUNT(DISTINCT product_key) AS total_products
FROM gold.dim_products;


-------------------------------
-- 6) Total Number of Customers
-------------------------------
SELECT 
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers;


-------------------------------
-- 7) Total Customers Who Placed Orders
-------------------------------
SELECT 
    COUNT(DISTINCT customer_key) AS customers_with_orders
FROM gold.fact_sales;


-------------------------------
-- 8) Summary Report of All Metrics
-------------------------------
SELECT 'Total Sales'          AS measure_name, SUM(sales_amount)               AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity'       AS measure_name, SUM(quantity)                   AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price'        AS measure_name, AVG(price)                      AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders'     AS measure_name, COUNT(DISTINCT order_number)    AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products'   AS measure_name, COUNT(DISTINCT product_key)     AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers'  AS measure_name, COUNT(DISTINCT customer_key)    AS measure_value FROM gold.dim_customers;