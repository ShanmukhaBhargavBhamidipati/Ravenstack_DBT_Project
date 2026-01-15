{{ config(materialized='table') }}

with date_bounds as (
    select
        min(signup_date) as min_date,
        date_add(current_date(), 730) as max_date
    from {{ ref('slvr_accounts') }}
),

date_spine as (
    select explode(
        sequence(min_date, max_date, interval 1 day)
    ) as date_day
    from date_bounds
)

select
    date_day                                   as date_key,
    date_day                                   as date,

    year(date_day)                             as year,
    quarter(date_day)                          as quarter,
    month(date_day)                            as month,
    date_format(date_day, 'MMMM')              as month_name,

    weekofyear(date_day)                       as week_of_year,
    day(date_day)                              as day_of_month,
    date_format(date_day, 'EEEE')              as day_name,

    case
        when date_day = current_date() then true
        else false
    end                                        as is_today,

    current_date()                             as dbt_loaded_at

from date_spine