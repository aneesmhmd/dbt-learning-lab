-- Splits global trends into Rising vs Stable
-- Useful for trend comparison dashboards

{{
    config(
        incremental_strategy='insert_overwrite',
        unique_key=['term', 'country_code', 'week'],
        partition_by={
            "field": "week",
            "data_type": "date",
            "granularity": "day"
        },
        cluster_by=['country_code', 'trend_type', 'term']
    )
}}

WITH base AS (
    SELECT * FROM {{ ref('tfm_global_trends') }}

    {% if is_incremental() %}
        WHERE week > (SELECT MAX(week) FROM {{ this }})
    {% endif %}
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