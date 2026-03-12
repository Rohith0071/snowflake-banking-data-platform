/* =========================================================
   DATA GOVERNANCE

   Dynamic Data Masking for sensitive data.

   SSN is masked for all users except governance roles.
========================================================= */

CREATE OR REPLACE MASKING POLICY ssn_mask AS (val STRING)
RETURNS STRING ->
CASE
WHEN CURRENT_ROLE() IN ('GOVERNANCE_ADMIN_ROLE','ACCOUNTADMIN')
THEN val
ELSE '***-**-****'
END;


-- Apply masking to SSN column
ALTER TABLE banking_db.silver.customers_profile
MODIFY COLUMN ssn
SET MASKING POLICY ssn_mask;
