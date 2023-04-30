# Week 3 Questions 

> Conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions. Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product

## What is our overall conversion rate?

- **Answer:** 62%


_expand for SQL_

<details>

```sql

with session_counts as (
select
    count(distinct(case when event_type = 'checkout' then session_id end)) as checkout_sessions,
    count(distinct session_id) as total_sessions 
from events 
)

select 
    round(checkout_sessions / total_sessions,2) as total_conversion 
from session_counts 

```

</details>

### What is our conversion rate by product?

**Answer:**

| product_name | product_conversion_rate |
| --- | --- |
| string of pearls | 0.6094 |
| cactus	| 0.5556 | 
|arrow head	| 0.5556 |
| zz plant	| 0.5397 |
| bamboo	| 0.5373 |
| calathea makoyana	| 0.5192 |
| rubber plant	| 0.5185 |
| monstera	| 0.5102 |
| fiddle leaf fig |	0.5 |
 |majesty palm | 	0.4925 |
| aloe vera	| 0.4923 |
| devil's ivy	| 0.4889 |
| philodendron |	0.4839 |
| jade plant	| 0.4783 |
| pilea peperomioides	| 0.4746 |
| spider plant	| 0.4746 | 
| dragon tree	| 0.4677 |
| money tree	| 0.4643 |
| orchid	| 0.4595 |
| bird of paradise	| 0.4576 |
| ficus	 |0.4265 |
| birds nest fern	| 0.4231 |
| pink anthurium	| 0.4189 | 
| boston fern	| 0.4127 |
| alocasia polly	| 0.4118 |
| peace lily	| 0.4091 |
| ponytail palm	| 0.4058 |
| angel wings begonia	| 0.4 |
| snake plant	| 0.3973 |
| pothos	| 0.3443 |

_expand for SQL_

<details>

```sql

with summed_product_sessions as (
select 
    product_name,
    sum(num_order_sessions) as total_order_sessions,
    sum(num_total_sessions) as total_sessions 
from daily_product_conversions
group by 1 
)

select 
    product_name,
    round(total_order_sessions / total_sessions,4) as product_conversion_rate 
from summed_product_sessions 
order by product_conversion_rate desc 

```

</details>

## Macros 

I decided to start small and implemented a round_values macro that rounds values to 2 points. This could help with keeping reporting consistent and folks would not really have to think about rounding values.

Maybe not the _most_ critical path for a macro but I wanted to try something that wasn't the example. :) 

## Granting permissions 

I didn't do anything wild here, and just experimented with copy / pasting the example from the lecture but for the `reporting` role. 

## Packages 

I installed the following packages:

- dbt utils 
- dbt expectations 

in a "real world" scenario I could see some of the fivetran packages being really helpful for cleaning up data from marketing & ad sources. 


## Snapshots 

The following products changed from week 2 to 3:
- Monstera
- Philodendron
- Pothos
- String of pearls