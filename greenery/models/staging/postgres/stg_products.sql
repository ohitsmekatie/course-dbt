select 
    product_id,
    lower(name) as product_name,
    price,
    inventory
from {{ source('postgres', 'products') }}
