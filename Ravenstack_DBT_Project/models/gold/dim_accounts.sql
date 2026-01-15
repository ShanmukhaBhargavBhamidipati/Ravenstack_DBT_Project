{{ config(materialized='table') }}

select
    account_id,

    account_name,
    industry,
    country,

    plan_tier,
    seats,

    is_trial,
    churn_flag,

    referral_source,
    signup_date,

    current_date() as dbt_loaded_at

from {{ ref('slvr_accounts') }}
