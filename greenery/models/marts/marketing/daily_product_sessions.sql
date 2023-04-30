select 
    date(created_at) as event_day,
    product_id,
    count(distinct session_id) as num_total_sessions
from {{ ref('events') }}
where product_id is not null 
group by 1, 2
