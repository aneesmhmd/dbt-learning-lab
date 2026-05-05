
WITH customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

order_summary AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS lifetime_value,
        ROUND(AVG(total_amount), 2) AS avg_order_value,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        SUM(CASE WHEN status = 'delivered' THEN 1 ELSE 0 END) AS delivered_orders,
        SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_orders
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.full_name,
    c.email,
    c.city,
    c.country,
    COALESCE(s.total_orders,    0)  AS total_orders,
    COALESCE(s.lifetime_value,  0)  AS lifetime_value,
    COALESCE(s.avg_order_value, 0)  AS avg_order_value,
    s.first_order_date,
    s.last_order_date,
    COALESCE(s.delivered_orders,0)  AS delivered_orders,
    COALESCE(s.cancelled_orders,0)  AS cancelled_orders
FROM customers c
LEFT JOIN order_summary s USING (customer_id)