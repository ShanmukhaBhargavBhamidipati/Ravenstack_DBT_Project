with source as (

    select
        ticket_id,
        account_id,
        submitted_at,
        closed_at,
        resolution_time_hours,
        priority,
        first_response_time_minutes,
        satisfaction_score,
        escalation_flag
    from {{ source('ravenstack_dbt_project', 'ravenstack_support_tickets') }}

),

deduped as (

    select
        ticket_id,
        account_id,
        submitted_at,
        closed_at,
        resolution_time_hours,
        priority,
        first_response_time_minutes,
        satisfaction_score,
        coalesce(escalation_flag, false) as escalation_flag,
        row_number() over (
            partition by ticket_id
            order by submitted_at desc
        ) as row_num
    from source

)

select
    ticket_id,
    account_id,
    submitted_at,
    closed_at,
    resolution_time_hours,
    priority,
    first_response_time_minutes,
    satisfaction_score,
    escalation_flag
from deduped
where row_num = 1
