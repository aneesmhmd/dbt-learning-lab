SELECT
    customer_id,
    first_name,
    last_name,
    first_name || ' ' || last_name AS full_name,
    LOWER(email) AS email,
    city,
    country,
    created_at::date AS created_date
FROM {{ source('dbt_data', 'customers') }}
