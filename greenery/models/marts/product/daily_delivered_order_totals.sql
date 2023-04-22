
select 
    date(created_at) as order_day,
    sum(order_totals) as sum_order_totals 
from {{ ref('int_product__order_totals')}}
group by 1 
order by 1
