/*==============================================================
  Script: 01_database_exploration.sql
  Purpose: Explore database objects and inspect table structures
  Notes:
    - Useful for initial understanding of the database schema
    - INFORMATION_SCHEMA views are ANSI‑standard and recommended
==============================================================*/

-------------------------------
-- 1) Explore all objects in the database
-------------------------------
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA, TABLE_NAME;


-------------------------------
-- 2) Explore all columns for a specific table
--    Change table_name as needed
-------------------------------
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
ORDER BY ORDINAL_POSITION;