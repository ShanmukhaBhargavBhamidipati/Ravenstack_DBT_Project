with source as (
    select
        subscription_id,
        account_id,
        start_date,
        end_date as subscription_end_date,
        plan_tier,
        seats,
        mrr_amount,
        arr_amount,
        is_trial,
        upgrade_flag,
        downgrade_flag,
        churn_flag,
        billing_frequency,
        auto_renew_flag
    from {{ source('ravenstack_dbt_project', 'ravenstack_subscriptions') }}
),

deduped as (
    select
        subscription_id,
        account_id,
        start_date,
        subscription_end_date,
        plan_tier,
        coalesce(seats, 0) as seats,
        coalesce(mrr_amount, 0) as mrr_amount,
        coalesce(arr_amount, 0) as arr_amount,
        coalesce(is_trial, false) as is_trial,
        coalesce(upgrade_flag, false) as upgrade_flag,
        coalesce(downgrade_flag, false) as downgrade_flag,
        coalesce(churn_flag, false) as churn_flag,
        billing_frequency,
        coalesce(auto_renew_flag, false) as auto_renew_flag,
        row_number() over (
            partition by subscription_id
            order by start_date desc
        ) as row_num
    from source
)

select
    subscription_id,
    account_id,
    start_date,
    subscription_end_date,
    plan_tier,
    seats,
    mrr_amount,
    arr_amount,
    is_trial,
    upgrade_flag,
    downgrade_flag,
    churn_flag,
    billing_frequency,
    auto_renew_flag
from deduped
where row_num = 1
