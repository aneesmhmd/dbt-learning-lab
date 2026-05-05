SELECT
    order_id,
    customer_id,
    order_date,
    LOWER(status) AS status,
    total_amount,
    created_at::date AS created_date
FROM {{ source('dbt_data', 'orders') }}
