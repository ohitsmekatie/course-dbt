select 
    product_id,
    lower(name) as product_name,
    price as product_price_dollars,
    inventory as inventory_amount 
from {{ source('postgres', 'products') }}
