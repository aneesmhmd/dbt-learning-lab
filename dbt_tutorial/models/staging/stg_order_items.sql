SELECT
    item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    quantity * unit_price   AS total_price,
    created_at::date        AS created_date
FROM {{ source('dbt_data', 'order_items') }}
