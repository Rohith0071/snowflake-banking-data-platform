/* =========================================================
   SNOWFLAKE TASKS

   Automates pipeline execution.

   Pipeline Flow:

   Bronze → Silver → Gold
========================================================= */


/* =========================================================
   TASK 1
   Incrementally load transactions into SILVER layer
========================================================= */

CREATE OR REPLACE TASK merge_tx_to_silver
WAREHOUSE = ingest_wh
SCHEDULE = '1 MINUTE'
WHEN SYSTEM$STREAM_HAS_DATA('transactions_stream')
AS
MERGE INTO banking_db.silver.transactions_silver target
USING (
SELECT *
FROM banking_db.bronze.transactions_stream
WHERE METADATA$ACTION = 'INSERT'
) src
ON target.tx_id = src.tx_id
WHEN MATCHED THEN
UPDATE SET target.amount = src.amount
WHEN NOT MATCHED THEN
INSERT (tx_id,cust_id,amount,status)
VALUES (src.tx_id,src.cust_id,src.amount,'PROCESSED');

ALTER TASK merge_tx_to_silver RESUME;


/* =========================================================
   TASK 2
   Load customer profile data into SILVER layer
========================================================= */

CREATE OR REPLACE TASK load_customer_profiles_task1
WAREHOUSE = ingest_wh
AFTER merge_tx_to_silver
AS
CALL banking_db.silver.sp_load_customer_profiles();

ALTER TASK load_customer_profiles_task1 RESUME;
