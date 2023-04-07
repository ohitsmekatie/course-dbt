select 
    lower(promo_id) as promo_id,
    discount,   
    status 
from {{ source('postgres', 'promos') }}
