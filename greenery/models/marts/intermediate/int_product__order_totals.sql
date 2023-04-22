select
    created_at,
    sum(order_total) as order_totals
from {{ ref('stg_orders') }}
where status = 'delivered'
group by 1
