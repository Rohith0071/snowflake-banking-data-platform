# Snowflake Banking Data Platform

## Overview

This project demonstrates the design and implementation of a **modern cloud data platform for a retail banking system using Snowflake**.
The platform ingests raw data from **AWS S3**, processes it using **Snowflake Streams and Tasks**, applies **data governance policies**, and exposes **business-ready analytical datasets** for BI tools.

The architecture follows the **Medallion Architecture (Bronze → Silver → Gold)** pattern to ensure scalable, reliable, and governed data processing.

---

## Architecture

The platform is designed with three logical data layers:

**Bronze Layer – Raw Data Ingestion**

* Loads raw data from AWS S3
* Stores original data with minimal transformation
* Supports structured (CSV) and semi-structured (JSON) formats

**Silver Layer – Data Transformation**

* Cleans and standardizes Bronze data
* Removes inconsistencies and prepares data for analytics
* Uses Snowflake Streams and Tasks for incremental processing

**Gold Layer – Business Analytics**

* Creates dimensional and fact tables
* Optimized for reporting, dashboards, and BI tools

Pipeline Flow:

S3 → Snowflake Stage → Bronze Tables → Streams → Tasks → Silver Tables → Gold Analytics

---

## Key Features

### Medallion Data Architecture

* Bronze → Silver → Gold data modeling
* Separation of ingestion, transformation, and analytics

### Automated Data Pipelines

* Snowflake **Streams** for Change Data Capture (CDC)
* Snowflake **Tasks** for automated incremental pipelines

### Data Governance

* **RBAC (Role-Based Access Control)** for secure access management
* **Dynamic Data Masking** for sensitive data such as SSN

### Scalable Compute

* Separate Snowflake warehouses for:

  * Data ingestion
  * Transformation workloads

### Semi-Structured Data Handling

* JSON support using **VARIANT** data type

---

## Project Structure

```
snowflake-banking-data-platform
│
├── README.md
├── architecture
│   └── architecture-diagram.png
│
├── sql
│   ├── create_tables.sql
│   ├── bronze_layer.sql
│   ├── silver_layer.sql
│   └── gold_layer.sql
│
├── pipelines
│   ├── streams.sql
│   └── tasks.sql
│
├── security
│   ├── rbac_roles.sql
│   └── dynamic_masking.sql
│
└── docs
    └── project_overview.md
```

---

## Data Model

### Bronze Layer Tables

| Table           | Description                           |
| --------------- | ------------------------------------- |
| customers       | Raw customer data from source systems |
| transactions    | Raw banking transaction records       |
| support_tickets | Customer support data stored as JSON  |

### Silver Layer Tables

| Table               | Description                        |
| ------------------- | ---------------------------------- |
| transactions_silver | Cleaned and processed transactions |
| customers_profile   | Curated customer profile dataset   |

### Gold Layer Tables

| Table             | Description                                 |
| ----------------- | ------------------------------------------- |
| dim_customers     | Customer dimension table                    |
| fact_transactions | Fact table containing enriched transactions |
| agg_transactions  | Aggregated metrics for reporting            |

---

## Data Pipeline

### Step 1 – Data Ingestion

Raw files are uploaded to **AWS S3** and loaded into Snowflake using an **external stage and COPY command**.

Data Sources:

* customer_profiles.csv
* transactions.csv
* support_tickets.json

---

### Step 2 – Change Data Capture

A **Snowflake Stream** captures changes from the Bronze transaction table.

```
transactions_stream
```

This allows the pipeline to process **only newly inserted records**.

---

### Step 3 – Transformation

Snowflake **Tasks** automate the data pipeline:

Task Chain:

```
Bronze → Silver → Gold
```

1. `merge_tx_to_silver`

   * Reads new records from the stream
   * Loads them into the Silver layer

2. `load_customer_profiles_task`

   * Refreshes customer profile data

3. `update_gold_layer`

   * Updates fact and analytics tables

---

## Security & Governance

### Role-Based Access Control

Three primary roles are used:

| Role                  | Purpose                 |
| --------------------- | ----------------------- |
| ingest_svc_role       | Data ingestion services |
| sysadmin_fin_role     | Database administration |
| governance_admin_role | Data governance         |

---

### Dynamic Data Masking

Sensitive data such as **SSN** is protected using Snowflake masking policies.

Example:

```
***-**-****
```

Only governance roles can see the actual value.

---

## Technologies Used

| Technology        | Purpose                           |
| ----------------- | --------------------------------- |
| Snowflake         | Cloud data warehouse              |
| AWS S3            | Data lake storage                 |
| SQL               | Data modeling and transformations |
| Snowflake Streams | Change Data Capture               |
| Snowflake Tasks   | Pipeline automation               |
| RBAC              | Access control                    |
| Dynamic Masking   | Data governance                   |

---

## Example Analytical Query

Example query combining fact and dimension tables:

```
SELECT 
    t.tx_id,
    t.amount,
    c.full_name,
    c.region,
    c.tier
FROM banking_db.gold.fact_transactions t
JOIN banking_db.gold.dim_customers c
ON t.cust_id = c.cust_id;
```

This query supports **customer transaction analysis and reporting**.

---

## Use Cases

The platform can support analytics such as:

* Regional transaction analysis
* Customer tier performance
* Fraud detection pipelines
* Financial reporting dashboards

---


