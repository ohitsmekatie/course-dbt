with orders_w_items as (
    select 
        stg_orders.created_at as order_date,
        stg_products.product_name,
        sum(stg_order_items.product_quantity) as num_products_ordered
    from {{ ref('stg_orders') }} 
    inner join {{ ref('stg_order_items') }} 
        on stg_orders.order_id = stg_order_items.order_id 
    inner join {{ ref('stg_products') }} 
        on stg_products.product_id = stg_order_items.product_id 
    group by 1,2
)

select * from orders_w_items 
