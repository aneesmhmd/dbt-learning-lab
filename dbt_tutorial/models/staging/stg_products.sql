SELECT
    product_id,
    product_name,
    UPPER(category) AS category,
    unit_price,
    stock_quantity,
    created_at::date AS created_date
FROM {{ source('dbt_data', 'products') }}
