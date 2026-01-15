{{ config(materialized='table') }}

with usage_base as (

    select
        usage_id,
        subscription_id,
        usage_date,
        feature_name,
        usage_count,
        usage_duration_secs,
        error_count,
        is_beta_feature
    from {{ ref('slvr_feature_usage') }}

),

date_spine as (

    select date_key
    from {{ ref('dim_dates') }}

),

expanded as (

    select
        u.usage_id,
        u.subscription_id,
        d.date_key,
        u.feature_name,
        u.usage_count,
        u.usage_duration_secs,
        u.error_count,
        u.is_beta_feature,

        true as is_active
    from usage_base u
    join date_spine d
      on d.date_key = u.usage_date

)

select
    usage_id,
    subscription_id,
    date_key,
    feature_name,
    usage_count,
    usage_duration_secs,
    error_count,
    is_beta_feature,
    is_active,
    current_timestamp() as dbt_loaded_at

from expanded
