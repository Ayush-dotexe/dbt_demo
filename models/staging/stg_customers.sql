{{ config(materialized='table') }}

with raw_customers as (
  select
    id as customer_id,
    first_name,
    last_name,
    created_date
  from {{ source('raw','customers') }}
),

full_name as (
  select
    customer_id,
    first_name || ' ' || last_name as name,
    created_date
  from raw_customers
)

select
  customer_id,
  name,
  created_date
  -- country   -- <- INTENTIONAL: real source has no `country` column; static analysis / LSP should flag this
from full_name
