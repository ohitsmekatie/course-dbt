{{ config(materialized='table') }}

select 
    date(order_date) as order_day,
    product_name,
    sum(num_products_ordered) as num_products_ordered 
from {{ ref('int_product__products_sold') }}
group by 1,2
order by 1 