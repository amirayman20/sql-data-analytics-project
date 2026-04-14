/*==============================================================
  Script: 03_date_range_exploration.sql
  Purpose: Explore order date range and customer age distribution
  Notes:
    - Helps understand timeline coverage and customer demographics
==============================================================*/


-------------------------------
-- 1) Find the first and last order dates
--    Also calculates the range in months
-------------------------------
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;


-------------------------------
-- 2) Find youngest and oldest customers
--    Based on birthdate field
-------------------------------
SELECT 
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;