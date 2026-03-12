/* =========================================================
   GOLD LAYER ANALYTICS

   Purpose:
   The Gold Layer contains business-ready tables
   optimized for BI tools, dashboards, and reporting.

   These tables are highly curated and aggregated.

   Data Sources:
   - silver.transactions_silver
   - silver.customers_profile

   Tables Created:
   - gold.dim_customers
   - gold.fact_transactions
   - gold.agg_transactions
========================================================= */

USE DATABASE banking_db;
USE SCHEMA gold;


/* =========================================================
   TABLE: dim_customers

   Description:
   Dimension table containing customer attributes.

   Used for:
   - Customer segmentation
   - Regional analysis
   - Tier-based analytics

   Source:
   silver.customers_profile
========================================================= */

CREATE OR REPLACE TABLE dim_customers AS
SELECT
    cust_id,
    full_name,
    region,
    tier
FROM banking_db.silver.customers_profile;



/* =========================================================
   TABLE: fact_transactions

   Description:
   Fact table storing transactional data enriched with
   customer attributes.

   Used for:
   - Financial reporting
   - Transaction analysis
   - Revenue analytics

   Source Tables:
   - silver.transactions_silver
   - silver.customers_profile
========================================================= */

CREATE OR REPLACE TABLE fact_transactions AS
SELECT
    t.tx_id,
    t.cust_id,
    t.amount,
    t.tx_type,
    t.time_stamp,
    c.region,
    c.tier
FROM banking_db.silver.transactions_silver t
JOIN banking_db.silver.customers_profile c
ON t.cust_id = c.cust_id;



/* =========================================================
   TABLE: agg_transactions

   Description:
   Aggregated transaction metrics for BI dashboards.

   Metrics:
   - Total transactions
   - Total transaction amount

   Dimensions:
   - Region
   - Transaction type
========================================================= */

CREATE OR REPLACE TABLE agg_transactions AS
SELECT
    region,
    tx_type,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM banking_db.gold.fact_transactions
GROUP BY region, tx_type;
