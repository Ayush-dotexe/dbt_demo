{{ config(materialized='table') }}

with last_30 as (
  select customer_id, amount
  from {{ ref('stg_orders') }}
  where order_ts >= dateadd(day, -30, current_date)
),

agg as (
  select
    customer_id,
    count(*) as orders_30d,
    sum(amount) as value_30d
  from last_30
  group by customer_id
),

joined as (
  select
    a.customer_id,
    a.orders_30d,
    a.value_30d,
    c.name as customer_name
  from agg a
  left join {{ ref('stg_customers') }} c on c.customer_id = a.customer_id
)

select * from joined
