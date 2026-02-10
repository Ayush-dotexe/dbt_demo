{{ config(materialized='table') }}

with raw_orders as (

    select
      id as order_id,
      customer_id,
      amount,
      order_ts as order_timestamp
    from {{ source('raw','orders') }}

)
,normalized as (
    select
      order_id,
      customer_id,
      amount,
      cast(order_timestamp as timestamp) as order_ts
    from raw_orders
)

select * from normalized
