/* =========================================================
   RBAC & INFRASTRUCTURE SETUP
   This script creates roles, warehouses, and S3 integration
   used for the banking data platform.

   Roles:
   - ingest_svc_role      → used by ingestion services
   - sysadmin_fin_role    → manages database objects
   - governance_admin_role → manages security & masking
========================================================= */

-- Create roles
create role ingest_svc_role;
create role sysadmin_fin_role;
create role governance_admin_role;

-- Role hierarchy
grant role ingest_svc_role to role sysadmin_fin_role;
grant role sysadmin_fin_role to role SYSADMIN;


/* =========================================================
   WAREHOUSES
   Separate warehouses for ingestion and compute workloads
========================================================= */

-- Warehouse used for ingestion and pipeline tasks
CREATE OR REPLACE WAREHOUSE ingest_wh
WAREHOUSE_SIZE = 'SMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE;

-- Warehouse used for transformations & analytics
CREATE OR REPLACE WAREHOUSE compute_wh
WAREHOUSE_SIZE = 'MEDIUM'
AUTO_SUSPEND = 120
AUTO_RESUME = TRUE;


/* =========================================================
   STORAGE INTEGRATION
   Connect Snowflake with AWS S3 bucket for data ingestion
========================================================= */

CREATE OR REPLACE STORAGE INTEGRATION s3_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
ENABLED = TRUE
STORAGE_ALLOWED_LOCATIONS = ('s3://retail-bank-s3')
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::328944070030:role/bank-role';


/* =========================================================
   DATABASE CREATION
========================================================= */

create database banking_db;

GRANT ALL PRIVILEGES ON DATABASE banking_db TO ROLE sysadmin_fin_role;
GRANT ALL PRIVILEGES ON DATABASE banking_db TO ROLE ingest_svc_role;
