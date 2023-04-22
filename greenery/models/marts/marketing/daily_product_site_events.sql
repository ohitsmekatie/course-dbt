{{ config(materialized='table') }}

select 
    date(created_at) as event_day,
    product_name,
    event_type,
    sum(num_events) as num_events 
from {{ ref('int_marketing__product_site_performance') }}
group by 1,2,3
order by 1,2,3