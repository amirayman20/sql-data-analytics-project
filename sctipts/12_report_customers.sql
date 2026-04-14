/*==============================================================
  Script: report_customer.sql
  Purpose: Create a customer-level analytical view with key KPIs
  Notes:
    - Includes segmentation, recency, AOV, monthly spend, and lifespan
==============================================================*/


-------------------------------
-- Drop existing view if exists
-------------------------------
DROP VIEW IF EXISTS gold.report_customer;
GO


-------------------------------
-- Create Customer Report View
-------------------------------
CREATE VIEW gold.report_customer AS 


/*==============================================================
  1) Base Query
     - Extracts raw transactional and customer fields
==============================================================*/
WITH base_query AS (
    SELECT 
        s.order_number,
        s.product_key,
        s.order_date,
        s.sales_amount,
        s.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = s.customer_key
    WHERE s.order_date IS NOT NULL
),


/*==============================================================
  2) Customer Aggregation
     - Aggregates customer-level metrics:
       total orders, total sales, total quantity, total products,
       last order date, lifespan (months)
==============================================================*/
customer_aggregation AS (
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY 
        customer_key,
        customer_number,
        customer_name,
        age
)


/*==============================================================
  3) Final Customer Report
     - Adds segmentation, recency, AOV, monthly spend
==============================================================*/
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,

    -- Age segmentation
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 And Above'
    END AS age_segment,

    -- Customer segmentation
    CASE 
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    -- Recency (months since last order)
    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,

    -- Aggregated metrics
    total_orders,
    total_sales,
    total_quantity,
    total_products,

    -- Average Order Value
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,

    -- Average Monthly Spend
    CASE 
        WHEN lifespan = 0 THEN 0
        ELSE total_sales / lifespan
    END AS avg_monthly_spent,

    lifespan

FROM customer_aggregation;