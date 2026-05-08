-- Splits global trends into Rising vs Stable
-- Useful for trend comparison dashboards

WITH base AS (
    SELECT * FROM {{ ref('tfm_global_trends') }}
),

classified AS (
    SELECT
        week,
        country_code,
        country_name,
        term,
        trend_score,
        percent_gain,
        trend_momentum,
        trend_strength,

        -- Simple binary classification
        CASE
            WHEN trend_momentum IN ('Breakout', 'Rising Fast', 'Rising')
                THEN 'Rising'
            ELSE 'Stable'
        END                             AS trend_type,

        -- Flag breakout terms specifically
        CASE
            WHEN trend_momentum = 'Breakout' THEN TRUE
            ELSE FALSE
        END                             AS is_breakout,

        CURRENT_TIMESTAMP()             AS loaded_at
    FROM base
)

SELECT * FROM classified