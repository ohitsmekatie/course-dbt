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

</details>

## What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

### Ideas for indicators of purchasing again
- A user who has completed > 1 order and then adds something to their cart (where added_to_cart event_date > last_purchase_date)
  - :sweeat: This one might be a little onvious, but a user who has already completed an order but then adds something to their cart is show intent to purchase again
- Repeat visitors to the site 
  - if a user has come back to the site week over week for a certain amount of weeks it shows interest in your product and possibly they would be more likely to purchase 
- Amount of money spent over time 

### Ideas for indicators of not purchasing againg
- Lapsing in visits. If a user moves from repeat visitor to not visiting at all in a given time period it could show they are churning
- If we had the data available, maybe something around returns or refunds? You could look into if returning and refunding an item after purchase showed users were less likely to return 

## Explain the product mart models you added. Why did you organize the models in the way you did?

**A few notes about why I organized my project the way I did:**

- I decided to move my `intermediate` models into their own folder on the same level as the product, core, and marketing folders so that they have their own schema so they wouldn't be obvious/visible to end users of the data. Because of this I just prefaced everyting with `int_product__*` or `int_marketing__*` so that they were a little easier to identify. I also kept these to the date timestamps because I imagined that othe date grains outside of daily might be needed down the road
- I tried to organize the models by functional area:
  - Product: if teams were split into engineering areas, I tried to imagine what a Product Manager or business stakeholder might care about 
  - Marketing: models focused around the website or users 
  - Core: the foundational elements of the business (users, orders, items, products) that i imagined could be useful on their own
- I materialized all the "end user" models as tables since these are the ones that are most likely to be queried. Instead of setting the configs in each of the files I just did that in the `dbt_project.yml` file at the folder level which was very handy!
- I also used the folders in `dbt_project.yml` to create some tags which helped me run only select models as I was testing things out

### Explanation of different models:

**Product:**

-  `daily_delivered_order_totals`: to understand the order totals of orders that were delivered 

<img width="328" alt="Screen Shot 2023-04-22 at 4 07 15 PM" src="https://user-images.githubusercontent.com/9855295/233804274-3ce93d24-d575-4733-8435-6bdc243e8842.png">


- `daily_orders_by_status`: daily orders by status could help folks identify patterns in shipping types. Perhaps it could help identified issues on the fullfillment side 

<img width="395" alt="Screen Shot 2023-04-22 at 4 08 12 PM" src="https://user-images.githubusercontent.com/9855295/233804309-81b0f764-fa69-4f1f-9a47-454a056e2cda.png">

- `daily_products_sold`: to keep an eye on the number of units sold, per product 

<img width="534" alt="Screen Shot 2023-04-22 at 4 08 52 PM" src="https://user-images.githubusercontent.com/9855295/233804332-9ca1f51e-c121-4c5e-9b64-6593f5e02146.png">

**Marketing**
- `page_views`: page views from the website. I could see this going in product or marketing, but decided marketing. This is just from the event view where event_type = 'page_view'
- `daily_product_site_events`: a daily view of event types by each product for the website

<img width="606" alt="Screen Shot 2023-04-22 at 4 03 45 PM" src="https://user-images.githubusercontent.com/9855295/233804191-99cc0718-28f5-4077-bbec-cbcee4527d02.png">

- `users_enhanced`: a beefed up version of the core user table that could give business stakeholders information about how much a user has spent, when their first order was, their last order, time between signup date to first order placed, etc

<img width="1362" alt="Screen Shot 2023-04-22 at 4 05 27 PM" src="https://user-images.githubusercontent.com/9855295/233804220-f213f4dd-9077-41fb-8634-4f8b9acc31d1.png">

**Core**

Everything here is pretty much as-is in the staging models, but I did add country & state into the `users` model incase folks wanted to map trends in signups by geo or orders by geo

- `users`
- `orders`
- `order_items`
- `products`

## Testing thoughts 

I added all my main tests at the staging layers, unless anything was specific to a transformation down the line. I felt like this was the easiest/best way to ensure all downstream data was the same as well as reduce the number of places I needed to actually add tests. I didn't go _super_ deep on the types of tests because of time, but i'm excited to try out a few more of the more "complex" tests in dbt expectations. For now, I started with:

1. making sure dates were not in the future
2. values that you would expect to be > 0 are
3. totals match in the order table
4. values you'd expect to be unique or null are  

### What assumptions are you making about each model?

- `user_id` will be unique to a user 
- a `user_id` should not be null 
- id's of each table will be unique and not null (product_id, event_id, etc)
- user's will always have a created date if they are in the `user` source table and that will never be null 
- a product's inventory will always be > 0 
- a user's `created_at` or an order's `created_at` cannot be greater than the current date 
- `order_cost`, `shipping_cost`, and `order_total` will be > $0
- product_price_dollars will always be > $0 
- tracking_id's for orders should be unique 

### Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

- There are 61 occurences of order_cost + shipping_cost != order_total. I removed these from the model for now, and decided to keep the test in place. 
- There are 6 occurences of the tracking_id being repeated for different orders (different user_id's, different order amounts). i would expect this to be an issue but that could be a wrong assumption so for now i've just commented out that test


## Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

The `dbt build` command runs and tests your models (as i understand). If you don't have an automated way to set this up you could run these daily and communicate the % of successful tests (or some kind of useful aggregate). Hopefully your tests catch any bad data as it slips through, but if it did I would just communicate what the bad data was and that it would be removed and tested for in the future. If needed, you might have to go to the source of the data quality issue (perhaps a team/process) to get that fixed. 

I'm not sure what kind of integrations exist within dbt, but it would be cool to be able to do automated alerts when build/runs fail to something like Slack or even email.
