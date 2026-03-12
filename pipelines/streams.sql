/* =========================================================
   SNOWFLAKE STREAMS

   Streams capture CDC (Change Data Capture)
   from Bronze tables to support incremental pipelines.
========================================================= */

use schema banking_db.bronze;

-- Stream to capture changes in transactions table
CREATE OR REPLACE STREAM transactions_stream
ON TABLE transactions;
