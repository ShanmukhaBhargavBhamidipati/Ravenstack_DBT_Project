# Phase 6: Project Summary & Deliverables

This document summarizes the final phase of the **Ravenstack Analytics Platform** dbt project, covering the gold layer, testing, highlights, and next steps.

---

## 6.1 Project Overview

The **Ravenstack Analytics Platform** is an end-to-end analytics engineering project built on **dbt Core** with **Databricks** as the data warehouse. It follows the **medallion architecture (bronze → silver → gold)** to transform raw SaaS subscription and usage data into analytics-ready models.

The project focuses on answering core business questions such as:
- Monthly Recurring Revenue (MRR) trends
- Active customer counts and churn
- Plan upgrades/downgrades
- Feature usage patterns
- Support ticket metrics (resolution, satisfaction, escalation)

The dataset originates from Kaggle, containing accounts, subscriptions, churn events, feature usage, and support tickets.

---

## 6.2 Medallion Architecture Mapping

| Layer  | dbt Representation                       | Purpose                                          |
|--------|------------------------------------------|--------------------------------------------------|
| Bronze | `sources` (raw tables)                   | Raw data ingested from Kaggle CSVs               |
| Silver | `slvr_` models (staging layer)            | Cleaned and standardized data                    |
| Gold   | `dim_` & `fact_` models (analytics layer)| Aggregated, BI-ready star schema tables          |

This design mirrors modern **Databricks production systems** with separate layers for raw ingestion, cleaning, and analytics-ready modeling.

---

## 6.3 Gold Layer Details

### **Dimensions**

1. **dim_accounts**  
   Contains one row per customer account and serves as the primary dimension for subscriptions, usage, churn, and support analytics.

2. **dim_dates**  
   Contains date-level records for aggregations and time-based reporting.

### **Fact Tables**

1. **fact_subscriptions**  
   One row per subscription, including metrics like MRR, ARR, upgrade/downgrade flags, churn, and billing information.

2. **fact_feature_usage**  
   One row per subscription per day per feature, capturing usage count, duration, errors, and beta feature flags.

3. **fact_support_tickets**  
   One row per support ticket, tracking resolution times, satisfaction scores, first response time, priority, and escalation flags.

---

## 6.4 dbt Tests Implemented

- **Source-level tests:**  
  - `not_null` and `unique` for primary keys  
  - Referential integrity between related tables  

- **Staging model tests:**  
  - `not_null` for important fields  
  - `accepted_range` for numerical columns (e.g., MRR, usage counts)  
  - `accepted_values` for categorical columns (e.g., plan_tier)

- **Gold model tests:**  
  - Dimension table keys (`account_id`) uniqueness and not null  
  - Fact table primary keys uniqueness and foreign key not null  

This ensures **data quality, integrity, and analytics reliability** at all layers.

---

## 6.5 Project Highlights

- **Comprehensive dbt coverage:** Sources, staging, snapshots (SCD Type-2), facts, dimensions, incremental models, macros, documentation, and tests.
- **Realistic SaaS business scenario:** Subscription analytics, churn tracking, feature usage, and support metrics.
- **Star schema design:** Fact and dimension tables optimized for BI tools like Looker, Tableau, or Power BI.
- **Modern ELT approach:** Raw data stays in Databricks; transformations happen via dbt Core.
- **Version control & reproducibility:** All models, tests, and documentation are maintained in Git.

---

## 6.6 Next Steps / Enhancements

1. **Aggregated metrics**  
   - Monthly MRR, churn, retention, and LTV calculations in aggregate fact tables.

2. **Snapshots for subscriptions & churn**  
   - Track historical changes in plan tiers, churn status, and seat counts.

3. **Incremental models**  
   - Optimize large tables like feature_usage for daily updates.

4. **Dashboards & BI integration**  
   - Connect gold models to Tableau/Looker/Power BI for visualization.

5. **CI/CD & environment management**  
   - Automated dbt runs for dev, staging, and production environments.

6. **Optional enrichment**  
   - Integrate additional e-commerce datasets or external reference data for advanced analytics.

---

**Author:** Shanmukha Bhargav Bhamidipati  
**Project:** Ravenstack Analytics Platform (dbt Core)
