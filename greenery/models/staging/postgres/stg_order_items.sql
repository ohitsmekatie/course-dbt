select  
    order_id,
    product_id,
    quantity as product_quantity
from {{ source('postgres', 'order_items') }}
