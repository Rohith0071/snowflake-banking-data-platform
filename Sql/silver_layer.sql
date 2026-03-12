/* =========================================================
   SILVER LAYER TRANSFORMATION

   Purpose:
   The Silver Layer contains cleaned and structured data.
   It transforms raw Bronze data into curated datasets.

   Transformations include:
   - Data cleansing
   - Deduplication
   - Standardization
   - Preparing data for analytics

   Tables Used:
   - bronze.customers
   - bronze.transactions

   Tables Created:
   - silver.transactions_silver
   - silver.customers_profile
========================================================= */

USE DATABASE banking_db;
USE SCHEMA silver;


/* =========================================================
   TABLE: transactions_silver

   Description:
   Cleaned transactions table derived from bronze.transactions.

   Columns:
   tx_id      → Unique transaction ID
   cust_id    → Customer identifier
   amount     → Transaction amount
   tx_type    → Transaction type (purchase, refund, etc.)
   time_stamp → Timestamp of transaction
   status     → Processing status
========================================================= */

CREATE OR REPLACE TABLE transactions_silver (
    tx_id VARCHAR(10) NOT NULL,
    cust_id VARCHAR(10) NOT NULL,
    amount NUMBER(38,2),
    tx_type VARCHAR(20),
    time_stamp TIMESTAMP_NTZ,
    status VARCHAR(30),
    PRIMARY KEY (tx_id)
);



/* =========================================================
   TABLE: customers_profile

   Description:
   Curated customer master table derived from bronze.customers.

   This table is used for joining with transaction data
   in downstream analytical models.

   Sensitive column:
   - ssn (masked using dynamic masking policy)
========================================================= */

CREATE OR REPLACE TABLE customers_profile (
    cust_id VARCHAR(10) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(255),
    ssn VARCHAR(11),
    region VARCHAR(20),
    tier VARCHAR(20),
    PRIMARY KEY (cust_id)
);



/* =========================================================
   STORED PROCEDURE

   Procedure Name:
   sp_load_customer_profiles

   Purpose:
   Refresh the customers_profile table using Bronze data.

   Steps:
   1. Deletes old records
   2. Reloads fresh records from bronze.customers
========================================================= */

CREATE OR REPLACE PROCEDURE banking_db.silver.sp_load_customer_profiles()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN

    -- Remove old records
    DELETE FROM banking_db.silver.customers_profile;

    -- Reload customers from bronze layer
    INSERT INTO banking_db.silver.customers_profile
    SELECT * FROM banking_db.bronze.customers;

    RETURN 'Customer profiles refreshed successfully';

END;
$$;
