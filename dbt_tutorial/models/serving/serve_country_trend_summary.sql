-- One row per country per week
-- High-level summary of trending activity — great for executive dashboards

WITH base AS (
    SELECT * FROM {{ ref('tfm_trending_by_country') }}
),

-- Add a label based on avg percent gain
labeled AS (
    SELECT
        *,
        CASE
            WHEN avg_percent_gain >= 1000   THEN 'Highly Active'
            WHEN avg_percent_gain >= 500    THEN 'Active'
            WHEN avg_percent_gain >= 100    THEN 'Moderate'
            ELSE                                 'Low Activity'
        END                                 AS country_trend_activity
    FROM base
)

SELECT
    week,
    country_code,
    country_name,
    unique_terms,
    avg_trend_score,
    max_trend_score,
    avg_percent_gain,
    max_percent_gain,
    top_term,
    top_term_score,
    top_term_percent_gain,
    country_trend_activity,
    CURRENT_TIMESTAMP()                     AS loaded_at
FROM labeled