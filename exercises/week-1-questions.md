https://corise.com/course/analytics-engineering-with-dbt/v2/module/week-1-project-instructions

## How many users do we have?

**Answer:**  130 users 

_expand below for SQL_ 

<details>


```sql

select count(user_id) as num_users
from dev_db.dbt_katiesipos.stg_users 

```

</details>

## On average, how many orders do we receive per hour?

**Answer:**  7.52 orders per hour, on average

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

**Answer:** 3.89 days, on average

_expand below for SQL_ 

<details>

```sql

select
    round(avg(timediff(day, created_at, delivered_at)), 2) as avg_diff_days 
from dev_db.dbt_katiesipos.stg_orders 

```

</details>

## How many users have only made one purchase? Two purchases? Three+ purchases?


**Answer:** 
- 25 users placed 1 order 
- 28 users placed 2 orders
- 71 users placed >= 3 orders 

_expand below for SQL_ 

<details>

```sql

with order_counts as (
select 
    user_id, 
    count(order_id) as num_orders
from dev_db.dbt_katiesipos.stg_orders 
group by 1
)

select  
    num_orders, 
    count(user_id) 
from order_counts group by 1 order by 1 

```

</details>

## On average, how many unique sessions do we have per hour?

**Answer:** 16.33 unique sessions per hour, on average

_expand below for SQL_ 

<details>

```sql

with hourly_sessions as (
select 
    date_trunc(hour,created_at) as event_date_hour,
    count(distinct session_id) as num_unique_sessions
from dev_db.dbt_katiesipos.stg_events
group by 1 
)

select 
    round(avg(num_unique_sessions),2) as avg_hourly_sessions 
from hourly_sessions 

```

</details>