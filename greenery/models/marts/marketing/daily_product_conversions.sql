with products_ordered as (
select * from {{ ref('daily_product_order_sessions') }} 
),

product_sessions as (
select * from {{ ref('daily_product_sessions') }} 
),

product_conversions as (
select 
    products_ordered.event_day,
    products_ordered.product_id,
    num_order_sessions,
    num_total_sessions,
    round(num_order_sessions / num_total_sessions,4) as conversion_rate 
from products_ordered
inner join product_sessions 
    on products_ordered.event_day = product_sessions.event_day 
    and products_ordered.product_id = product_sessions.product_id
order by products_ordered.event_day 
)

select 
    product_conversions.event_day,
    products.product_name,
    product_conversions.num_order_sessions,
    product_conversions.num_total_sessions,
    product_conversions.conversion_rate 
from product_conversions
inner join {{ ref('products') }} 
    on product_conversions.product_id = products.product_id 
