# Ravenstack dbt Project – MercuryMart Analytics Platform

A realistic **end-to-end dbt Core analytics engineering project** built on Databricks, using the **medallion architecture** (bronze → silver → gold). The project models subscription, usage, support, and churn data for a SaaS company.

---

## Table of Contents

1. [Project Overview](#project-overview)  
2. [Dataset](#dataset)  
3. [Architecture](#architecture)  
4. [dbt Models](#dbt-models)  
5. [dbt Concepts Implemented](#dbt-concepts-implemented)  
6. [Project Phases](#project-phases)  
7. [Phase 6 Summary](#phase-6-summary)  
8. [Usage](#usage)  
9. [Future Enhancements](#future-enhancements)  
10. [References](#references)  

---

## Project Overview

MercuryMart is a subscription-based SaaS company. This project provides **trustworthy analytics** on revenue, customer growth, churn, plan upgrades/downgrades, and support metrics.  

The goal is to demonstrate **best practices in dbt**, including staging, dimension/fact modeling, snapshots, incremental models, and testing.

---

## Dataset

Primary dataset: **SaaS Subscription & Churn Analytics** (Kaggle)  

Includes tables:  

- `ravenstack_accounts`  
- `ravenstack_subscriptions`  
- `ravenstack_churn_events`  
- `ravenstack_feature_usage`  
- `ravenstack_support_tickets`  

This dataset supports **facts and dimensions**, **SCD Type‑2 snapshots**, and **incremental events** for robust analytics.

---

## Architecture

**ELT with dbt on Databricks:**

1. **Bronze Layer:** raw CSV data loaded into Databricks tables (`sources`)  
2. **Silver Layer:** staging models (`stg_`) for cleaning and standardizing  
3. **Gold Layer:** dimension and fact tables for BI and analytics  

**Star Schema Overview:**

**Dimensions:**

- `dim_accounts`  
- `dim_dates`  

**Facts:**

- `fact_subscriptions`  
- `fact_feature_usage`  
- `fact_support_tickets`  

---

## dbt Models

**Staging Models (Silver):**

- `stg_accounts`  
- `stg_subscriptions`  
- `stg_feature_usage`  
- `stg_churn_events`  
- `stg_support_tickets`  

**Gold Models:**

- `dim_accounts`  
- `dim_dates`  
- `fact_subscriptions`  
- `fact_feature_usage`  
- `fact_support_tickets`  

All models include **tests** for uniqueness, not-null, and accepted values.  

---

## dbt Concepts Implemented

- Sources (bronze tables)  
- Staging models (silver)  
- Fact & dimension models (gold)  
- Generic and custom tests  
- Snapshots (SCD Type‑2)  
- Incremental models  
- Jinja macros & templating  
- Documentation & lineage  
- Git & CI/CD concepts  

---

## Project Phases

1. **Phase 1 – Environment Setup:** Python, Git, dbt Core, Databricks connection  
2. **Phase 2 – Source & Raw Data Ingestion:** Load Kaggle CSVs into Databricks  
3. **Phase 3 – Staging Models:** Clean, typecast, and standardize columns  
4. **Phase 4 – Testing Sources & Staging Models:** Unique, not-null, and accepted range tests  
5. **Phase 5 – Gold Layer:** Build dimensions and facts for BI-ready analytics  
6. **Phase 6 – Analytics & Summary:** Relationships, grain definitions, and phase-wise documentation  

---

## Phase 6 Summary

For a detailed **phase-wise summary**, including **table grains, relationships, and testing**, see:  
[PHASE_6_SUMMARY.md](PHASE_6_SUMMARY.md)

---

## Usage

To run this project locally:  

```bash
# Activate virtual environment
source venv/bin/activate  # or `venv\Scripts\activate` on Windows

# Install dbt
pip install dbt-core dbt-databricks

# Run dbt models
dbt run

# Run dbt tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
