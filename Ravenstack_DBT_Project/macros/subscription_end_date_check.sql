{% test subscription_end_date_check(model, column_name) %}
    select *
    from {{ model }}
    where {{ column_name }} is not null
      and {{ column_name }} < start_date
{% endtest %}
