/*==============================================================
  Script: 10_data_segmentation.sql
  Purpose: Segment products by cost ranges and customers by spending behavior
  Notes:
    - Includes product segmentation and customer segmentation KPIs
==============================================================*/


/*==============================================================
  1) Segment products into cost ranges
     Count how many products fall into each segment
==============================================================*/
WITH product_segment AS (
    SELECT 
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC;



/*==============================================================
  2) Segment customers based on spending behavior
     - VIP:     lifespan >= 12 months AND spending > 5000
     - Regular: lifespan >= 12 months AND spending <= 5000
     - New:     lifespan < 12 months
==============================================================*/
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(s.sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = s.customer_key
    GROUP BY c.customer_key
)
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT 
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) t
GROUP BY customer_segment
ORDER BY customer_segment;