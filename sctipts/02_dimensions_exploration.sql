/*==============================================================
  Script: 02_dimensions_exploration.sql
  Purpose: Explore key dimensions used in analysis 
  Notes:
    - Focus on understanding customer distribution and product hierarchy
==============================================================*/


-------------------------------
-- 1) Explore all countries our customers come from
-------------------------------
SELECT DISTINCT 
    country
FROM gold.dim_customers
ORDER BY country;


-------------------------------
-- 2) Explore product categories and subcategories
--    Shows product hierarchy and naming structure
-------------------------------
SELECT DISTINCT 
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY 
    category,
    subcategory,
    product_name;