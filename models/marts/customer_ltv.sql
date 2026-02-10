{{ config(materialized='table') }}

with base as (
  select
    c.customer_id,
    c.name,
    coalesce(sum(o.amount),0) as total_value
  from {{ ref('stg_customers') }} c
  left join {{ ref('stg_orders') }} o on o.customer_id = c.customer_id
  group by c.customer_id, c.name
)

select * from base
