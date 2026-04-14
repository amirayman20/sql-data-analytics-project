/*==============================================================
  Script: 11_category_contribution_analysis.sql
  Purpose: Identify which product categories contribute most to total sales
  Notes:
    - Calculates each category's sales and its percentage of overall revenue
==============================================================*/


-------------------------------
-- Category contribution to overall sales
-------------------------------
WITH category_sales AS (
    SELECT 
        p.category,
        SUM(s.sales_amount) AS total_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON p.product_key = s.product_key
    GROUP BY p.category
)
SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(
        ROUND(
            CAST(total_sales AS FLOAT) 
            / SUM(total_sales) OVER () * 100, 
        2),
        '%'
    ) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;