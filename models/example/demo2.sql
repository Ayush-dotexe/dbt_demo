with abc as (
    select 
        product_id,
        product_name,
        category,
        price
    from {{source('db', 'products')}}
)
select * from abc