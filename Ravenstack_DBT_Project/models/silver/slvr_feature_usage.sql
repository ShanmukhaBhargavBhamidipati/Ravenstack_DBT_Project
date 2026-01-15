with source as (

    select
        usage_id,
        subscription_id,
        usage_date,
        feature_name,
        usage_count,
        usage_duration_secs,
        error_count,
        is_beta_feature
    from {{ source('ravenstack_dbt_project', 'ravenstack_feature_usage') }}

),

deduped as (

    select
        usage_id,
        subscription_id,
        usage_date,
        feature_name,
        coalesce(usage_count, 0)            as usage_count,
        coalesce(usage_duration_secs, 0)    as usage_duration_secs,
        coalesce(error_count, 0)             as error_count,
        coalesce(is_beta_feature, false)     as is_beta_feature,
        row_number() over (
            partition by usage_id
            order by usage_date desc
        ) as row_num

    from source

)

select
    usage_id,
    subscription_id,
    usage_date,
    feature_name,
    usage_count,
    usage_duration_secs,
    error_count,
    is_beta_feature
from deduped
where row_num = 1
