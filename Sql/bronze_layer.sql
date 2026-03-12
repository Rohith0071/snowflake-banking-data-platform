/* =========================================================
   BRONZE LAYER INGESTION

   This layer loads raw data from AWS S3 into Snowflake.

   Data Sources:
   - customer_profiles.csv
   - transactions4.csv
   - support_tickets.json
========================================================= */

use schema banking_db.bronze;


/* =========================================================
   STAGE CREATION
   External stage to access files in S3 bucket
========================================================= */

CREATE OR REPLACE STAGE s3_landing_stage
STORAGE_INTEGRATION = s3_int
URL = 's3://retail-bank-s3/';


/* =========================================================
   FILE FORMATS
========================================================= */

-- CSV file format
CREATE OR REPLACE FILE FORMAT my_csv_format
TYPE = CSV
FIELD_DELIMITER = ','
SKIP_HEADER = 1;

-- JSON file format
CREATE OR REPLACE FILE FORMAT my_json_format
TYPE = JSON
STRIP_OUTER_ARRAY = TRUE;


/* =========================================================
   DATA LOADING
========================================================= */

-- Load customers data
COPY INTO customers
FROM @s3_landing_stage/customer_profiles.csv
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format')
ON_ERROR = 'CONTINUE';


-- Load transaction data
COPY INTO transactions
FROM @s3_landing_stage/transactions4.csv
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format')
ON_ERROR = 'CONTINUE';


-- Load support tickets JSON
COPY INTO support_tickets
FROM @s3_landing_stage/support_tickets.json
FILE_FORMAT = (FORMAT_NAME = 'my_json_format')
ON_ERROR = 'CONTINUE';
