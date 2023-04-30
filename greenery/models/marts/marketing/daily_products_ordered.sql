with web_events as (
    select * from {{ ref('events') }} 
),

orders_w_items as (
    select * from {{ ref('order_items') }} 
)

select 
    date(web_events.created_at) as event_day,
    orders_w_items.product_id,
    count(distinct web_events.session_id) as num_order_sessions 
from web_events 
left join orders_w_items 
    on web_events.order_id = orders_w_items.order_id
where 
    web_events.order_id is not null 
    and web_events.event_type = 'checkout'
group by 1, 2
    