-- {% set project = target.project %}  -- Required only when querying across different projects
{% set dataset = target.dataset %}

-- WITH source AS (
--     SELECT * FROM `{{ project }}.{{ dataset }}.customers`
-- )

WITH source AS (
    SELECT * FROM `{{ dataset }}.customers`
)

SELECT
    customer_id,
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) AS full_name,
    LOWER(email) AS email,
    city,
    country,
    DATE(created_at) AS created_date
FROM source
