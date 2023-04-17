https://corise.com/course/analytics-engineering-with-dbt/v2/module/week-2-project-instructions

## What is our repeat user rate?

| total_users |	repeat_users |	repeat_user_rate |
| --- | --- | ---|
| 124 |	99 | 0.798387 |

_expand for SQL_

<details>

```sql

with orders_per_user as (
select 
    user_id, 
    count(order_id) as num_orders 
from dev_db.dbt_katiesipos.stg_orders
group by 1
),

counts as (
select 
    count(user_id) as total_users,
    count_if(num_orders >= 2) as repeat_users
from orders_per_user
)

select 
    total_users,
    repeat_users,
    repeat_users / total_users as repeat_user_rate 
from counts 

```

## What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

### Ideas for indicators of purchasing again
- A user who has completed > 1 order and then adds something to their cart (where added_to_cart event_date > last_purchase_date)
  - :sweeat: This one might be a little onvious, but a user who has already completed an order but then adds something to their cart is show intent to purchase again
- Repeat visitors to the site 
  - if a user has come back to the site week over week for a certain amount of weeks it shows interest in your product and possibly they would be more likely to purchase 

### Ideas for indicators of not purchasing againg
- Lapsing in visits. If a user moves from repeat visitor to not visiting at all in a given time period it could show they are churning
- If we had the data available, maybe something around returns or refunds? You could look into if returning and refunding an item after purchase showed users were less likely to return 