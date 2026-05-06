-- {% set project = target.project %}
{% set dataset = target.dataset %}

WITH source AS (
    SELECT * FROM `{{ dataset }}.orders`
)

SELECT
    order_id,
    customer_id,
    order_date,
    LOWER(status) AS status,
    total_amount,
    DATE(created_at) AS created_date
FROM source
