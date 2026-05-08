-- Top 10 trending terms per country per week
-- Ready for global trends dashboard

WITH base AS (
    SELECT * FROM {{ ref('tfm_global_trends') }}
)

SELECT
    week,
    country_code,
    country_name,
    region_code,
    region_name,
    term,
    trend_score,
    trend_rank,
    percent_gain,
    trend_momentum,
    trend_strength,
    country_week_rank,
    CURRENT_TIMESTAMP()             AS loaded_at
FROM base
WHERE country_week_rank <= 10     -- top 10 terms per country per week