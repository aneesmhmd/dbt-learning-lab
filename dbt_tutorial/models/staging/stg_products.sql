-- {% set project = target.project %}
{% set dataset = target.dataset %}

WITH source AS (
    SELECT * FROM `{{ dataset }}.products`
)

SELECT
    product_id,
    product_name,
    UPPER(category) AS category,
    unit_price,
    stock_quantity,
    DATE(created_at) AS created_date
FROM source
