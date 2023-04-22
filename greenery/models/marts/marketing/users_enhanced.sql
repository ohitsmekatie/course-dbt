
{{ config(materialized='table') }}

with users_w_orders as (
    select 
        users.user_id,
        date(users.created_at) as signup_date,
        orders.order_id,
        orders.created_at as order_date,
        orders.estimated_delivery_at,
        orders.delivered_at,
        orders.order_total,
        orders.promo_id
    from {{ ref('users') }} 
    left join {{ ref('orders') }} 
    on users.user_id = orders.user_id 
),

order_metrics as (
select 
    user_id,
    signup_date,
    coalesce(count(order_id),0) as num_orders,
    count(case when promo_id is not null then 1 else 0 end) as num_promos, 
    min(date(order_date)) as first_order_date,
    max(date(order_date)) as last_order_date,
    coalesce(sum(order_total),0) as total_dollars_spent
from users_w_orders
group by 1,2 
)

select 
    order_metrics.*,
    datediff('day', signup_date, first_order_date) as days_to_first_order
from order_metrics 