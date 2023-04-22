select
    created_at,
    status,
    count(order_id) as num_orders
from orders
group by 1,2
