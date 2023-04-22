{{ config(materialized='table') }}

select 
    date(created_at) as order_day,
    status,
    sum(num_orders) as total_orders
from {{ ref('int_product__order_statuses') }}
group by 1,2
order by 1,2
