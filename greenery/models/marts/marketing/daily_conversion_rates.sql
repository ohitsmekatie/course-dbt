with session_counts as (
select
    date(created_at) as event_day, 
    count(distinct(case when event_type = 'checkout' then session_id end)) as checkout_sessions,
    count(distinct session_id) as total_sessions 
from {{ ref('events') }} 
group by 1 
)

select 
    event_day,
    round(checkout_sessions / total_sessions, 4) as conversion_rate 
from session_counts 
order by 1 
