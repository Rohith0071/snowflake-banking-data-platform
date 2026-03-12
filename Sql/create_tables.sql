/* =========================================================
   DATABASE SCHEMA SETUP

   This project follows a Medallion Architecture:

   BRONZE  → Raw ingested data
   SILVER  → Cleaned & transformed data
   GOLD    → Business-ready analytics tables
========================================================= */

use database banking_db;


/* =========================================================
   CREATE SCHEMAS
========================================================= */

create schema bronze;
create schema silver;
create schema gold;


/* =========================================================
   BRONZE LAYER TABLES
   Raw data loaded directly from source files (S3)
========================================================= */

-- Customer master data
CREATE OR REPLACE TABLE bronze.customers (
    cust_id VARCHAR(10) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(255),
    ssn VARCHAR(11),
    region VARCHAR(20),
    tier VARCHAR(20),
    PRIMARY KEY (cust_id)
);

-- Transaction data from banking system
CREATE OR REPLACE TABLE bronze.transactions (
    tx_id VARCHAR(10) NOT NULL,
    cust_id VARCHAR(10),
    amount NUMBER(38,2),
    tx_type VARCHAR(20),
    time_stamp TIMESTAMP_NTZ,
    PRIMARY KEY (tx_id)
);

-- Support tickets stored as JSON
CREATE OR REPLACE TABLE bronze.support_tickets (
    payload VARIANT
);


/* =========================================================
   SILVER LAYER TABLES
   Cleaned & structured data used for downstream analytics
========================================================= */

-- Processed transactions table
CREATE OR REPLACE TABLE silver.transactions_silver (
    tx_id VARCHAR(10),
    cust_id VARCHAR(10),
    amount NUMBER(38,2),
    tx_type VARCHAR(20),
    time_stamp TIMESTAMP_NTZ,
    status VARCHAR(30),
    PRIMARY KEY (tx_id)
);

-- Customer dimension staging table
CREATE OR REPLACE TABLE silver.customers_profile (
    cust_id VARCHAR(10),
    full_name VARCHAR(100),
    email VARCHAR(255),
    ssn VARCHAR(11),
    region VARCHAR(20),
    tier VARCHAR(20),
    PRIMARY KEY (cust_id)
);
