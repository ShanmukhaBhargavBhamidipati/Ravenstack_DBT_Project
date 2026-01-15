with source as (

    select
        account_id,
        account_name,
        industry,
        country,
        signup_date,
        referral_source,
        plan_tier,
        seats,
        is_trial,
        churn_flag
    from {{ source('ravenstack_dbt_project', 'ravenstack_accounts') }}

),

deduped as (

    select
        account_id,
        account_name,
        industry,
        country,
        signup_date,
        referral_source,
        plan_tier,
        coalesce(seats, 0) as seats,
        coalesce(is_trial, false) as is_trial,
        coalesce(churn_flag, false) as churn_flag,
        row_number() over (
            partition by account_id
            order by signup_date desc
        ) as row_num
    from source

)

select
    account_id,
    account_name,
    industry,
    country,
    signup_date,
    referral_source,
    plan_tier,
    seats,
    is_trial,
    churn_flag
from deduped
where row_num = 1
