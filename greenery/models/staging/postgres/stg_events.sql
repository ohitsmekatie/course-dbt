select 
    event_id,
    session_id,
    user_id,
    order_id,
    product_id, 
    page_url, 
    created_at,
    event_type
from  {{source('postgres', 'events') }}

{% if target.name == 'dev' %}

where date(created_at) >= dateadd('week', -3, current_date)

{% endif %}

