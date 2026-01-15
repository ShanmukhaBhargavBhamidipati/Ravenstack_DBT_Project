with source as (

    select
        churn_event_id,
        account_id,
        churn_date,
        reason_code,
        refund_amount_usd,
        preceding_upgrade_flag,
        preceding_downgrade_flag,
        is_reactivation,
        feedback_text
    from {{ source('ravenstack_dbt_project', 'ravenstack_churn_events') }}

),

deduped as (

    select
        churn_event_id,
        account_id,
        churn_date,
        reason_code,
        coalesce(refund_amount_usd, 0.0) as refund_amount_usd,
        coalesce(preceding_upgrade_flag, false) as preceding_upgrade_flag,
        coalesce(preceding_downgrade_flag, false) as preceding_downgrade_flag,
        coalesce(is_reactivation, false) as is_reactivation,
        feedback_text,
        row_number() over (
            partition by churn_event_id
            order by churn_date desc
        ) as row_num
    from source

)

select
    churn_event_id,
    account_id,
    churn_date,
    reason_code,
    refund_amount_usd,
    preceding_upgrade_flag,
    preceding_downgrade_flag,
    is_reactivation,
    feedback_text
from deduped
where row_num = 1
