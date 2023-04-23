with product_events as (
    select * from {{ ref('stg_events')}} 
-- beacause we just want events that have a product id to be able to count them 
where product_id is not null 
)

select 
    product_events.created_at,
    stg_products.product_name,
    product_events.event_type,
    count(product_events.event_id) as num_events 
from product_events 
inner join {{ ref('stg_products') }} 
on product_events.product_id = stg_products.product_id 
group by 1,2,3
