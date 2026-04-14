/*==============================================================
  Script: 09_performance_analysis.sql
  Purpose: Analyze yearly product performance vs average and previous year
  Notes:
    - Compares each product's yearly sales to:
        1) Its overall average performance
        2) Previous year's performance
==============================================================*/


-------------------------------
-- CTE: Yearly sales per product
-------------------------------
WITH yearly_product_sales AS (
    SELECT
        YEAR(s.order_date) AS order_year,
        p.product_name,
        SUM(s.sales_amount) AS current_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON p.product_key = s.product_key
    WHERE YEAR(s.order_date) IS NOT NULL
    GROUP BY YEAR(s.order_date), p.product_name
)


-------------------------------
-- Final yearly performance analysis
-------------------------------
SELECT 
    order_year,
    product_name,
    current_sales,

    -- Compare to product's average performance
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales 
        - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,

    CASE 
        WHEN current_sales > AVG(current_sales) OVER (PARTITION BY product_name) THEN 'Above Avg'
        WHEN current_sales < AVG(current_sales) OVER (PARTITION BY product_name) THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,

    -- Compare to previous year's performance
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,

    CASE 
        WHEN current_sales > LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) THEN 'Increase'
        WHEN current_sales < LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change

FROM yearly_product_sales
ORDER BY product_name, order_year;