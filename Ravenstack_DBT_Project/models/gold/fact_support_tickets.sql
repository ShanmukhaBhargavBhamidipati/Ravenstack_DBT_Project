{{ config(materialized='table') }}

with tickets_base as (

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
    from {{ ref('slvr_support_tickets') }}

),

date_spine as (

    select date_key
    from {{ ref('dim_dates') }}

),

tickets_with_dates as (

    select
        t.ticket_id,
        t.account_id,
        d.date_key,
        t.closed_at,
        t.resolution_time_hours,
        t.priority,
        t.first_response_time_minutes,
        t.satisfaction_score,
        t.escalation_flag,
        true as is_active
    from tickets_base t
    join date_spine d
      on d.date_key = t.submitted_at

)

select
    ticket_id,
    account_id,
    date_key,
    closed_at,
    resolution_time_hours,
    priority,
    first_response_time_minutes,
    satisfaction_score,
    escalation_flag,
    is_active,
    current_timestamp() as dbt_loaded_at
from tickets_with_dates
