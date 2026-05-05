
WITH products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),

orders AS (
    SELECT order_id, status FROM {{ ref('stg_orders') }}
),

delivered_items AS (
    SELECT
        oi.product_id,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.total_price) AS total_revenue
    FROM order_items oi
    JOIN orders o USING (order_id)
    WHERE o.status = 'delivered'
    GROUP BY oi.product_id
)

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    p.stock_quantity,
    COALESCE(d.units_sold,   0) AS units_sold,
    COALESCE(d.total_revenue,0) AS total_revenue,
    ROUND(
        COALESCE(d.units_sold, 0) * 100.0
        / NULLIF(p.stock_quantity, 0), 2
    ) AS sell_through_rate_pct
FROM products p
LEFT JOIN delivered_items d USING (product_id)
ORDER BY total_revenue DESC
