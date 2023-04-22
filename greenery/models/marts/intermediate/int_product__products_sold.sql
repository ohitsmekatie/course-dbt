with orders_w_items as (
    select 
        orders.created_at as order_date,
        products.product_name,
        sum(order_items.product_quantity) as num_products_ordered
    from {{ ref('orders') }} 
    inner join {{ ref('order_items') }} 
        on orders.order_id = order_items.order_id 
    inner join {{ ref('products') }} 
        on products.product_id = order_items.product_id 
    group by 1,2
)

select * from orders_w_items 