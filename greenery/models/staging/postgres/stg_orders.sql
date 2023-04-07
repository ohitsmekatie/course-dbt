select  
    order_id,
    user_id,
    promo_id, 
    address_id, 
    tracking_id,
    created_at, 
    estimated_delivery_at,
    delivered_at, 
    order_cost, 
    shipping_cost,
    order_total, 
    shipping_service,
    status
from {{ source('postgres', 'orders') }}
