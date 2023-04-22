with product_events as (
select * from {{ ref('stg_events')}} 
where product_id is not null 
)

select 
    product_events.created_at,
    products.product_name,
    product_events.event_type,
    count(product_events.event_id) as num_events 
from product_events 
inner join {{ ref('products') }} 
on product_events.product_id = products.product_id 
group by 1,2,3

