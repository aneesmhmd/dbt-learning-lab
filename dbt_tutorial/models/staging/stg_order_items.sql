-- {% set project = target.project %}
{% set dataset = target.dataset %}

WITH source AS (
    SELECT * FROM `{{ dataset }}.order_items`
)

SELECT
    item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    quantity * unit_price AS total_price,
    DATE(created_at) AS created_date
FROM source
