## How many users do we have?

**Answer:**  130

_expand below for SQL_ 

<details>


```sql

select count(user_id) as num_users
from dev_db.dbt_katiesipos.stg_users 

```

</details>

## On average, how many orders do we receive per hour?

**Answer:**  7.52

_expand below for SQL_ 

<details>

```sql

with hourly_orders as (
select 
    date_trunc('hour', created_at) as hour,
    count(order_id) as num_orders
from dev_db.dbt_katiesipos.stg_orders
group by 1 
)

select round(avg(num_orders),2) as avg_hourly_orders
from hourly_orders 

```

</details>

## On average, how long does an order take from being placed to being delivered?

**Answer:** 

_expand below for SQL_ 

<details>

```sql

```

</details>

## How many users have only made one purchase? Two purchases? Three+ purchases?

Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

**Answer:** 

_expand below for SQL_ 

<details>

```sql

```

</details>

## On average, how many unique sessions do we have per hour?

**Answer:** 

_expand below for SQL_ 

<details>

```sql

```

</details>