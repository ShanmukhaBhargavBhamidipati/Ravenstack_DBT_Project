{{ config(materialized='table') }}

with subscriptions as (

    select
        subscription_id,
        account_id,
        plan_tier,
        start_date,
        subscription_end_date,
        mrr_amount,
        arr_amount,
        billing_frequency,
        is_trial,
        churn_flag,
        upgrade_flag,
        downgrade_flag
    from {{ ref('slvr_subscriptions') }}

),

date_spine as (

    select date_key
    from {{ ref('dim_dates') }}

),

expanded as (

    select
        s.subscription_id,
        s.account_id,
        d.date_key,

        s.plan_tier,
        s.mrr_amount,
        s.arr_amount,
        s.billing_frequency,
        s.is_trial,
        s.churn_flag,
        s.upgrade_flag,
        s.downgrade_flag,

        true as is_active

    from subscriptions s
    join date_spine d
      on d.date_key >= s.start_date
     and (
            s.subscription_end_date is null
         or d.date_key <= s.subscription_end_date
     )

)

select
    subscription_id,
    account_id,
    date_key,
    plan_tier,
    mrr_amount,
    arr_amount,
    billing_frequency,
    is_trial,
    churn_flag,
    upgrade_flag,
    downgrade_flag,
    is_active,

    current_timestamp() as dbt_loaded_at

from expanded
