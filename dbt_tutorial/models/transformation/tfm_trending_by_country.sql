-- Aggregates top rising terms per country per week
-- Useful for country-level trend summaries

WITH base AS (
    SELECT * FROM {{ ref('stg_intl_top_rising_terms') }}
),

aggregated AS (
    SELECT
        week,
        country_code,
        country_name,
        COUNT(DISTINCT term)            AS unique_terms,
        AVG(trend_score)                AS avg_trend_score,
        MAX(trend_score)                AS max_trend_score,
        AVG(percent_gain)               AS avg_percent_gain,
        MAX(percent_gain)               AS max_percent_gain
    FROM base
    GROUP BY week, country_code, country_name
),

-- Get the #1 trending term per country per week
top_term_per_country AS (
    SELECT
        week,
        country_code,
        term                            AS top_term,
        trend_score                     AS top_term_score,
        percent_gain                    AS top_term_percent_gain
    FROM base
    WHERE trend_rank = 1
)

SELECT
    a.week,
    a.country_code,
    a.country_name,
    a.unique_terms,
    ROUND(a.avg_trend_score, 2)         AS avg_trend_score,
    a.max_trend_score,
    ROUND(a.avg_percent_gain, 2)        AS avg_percent_gain,
    a.max_percent_gain,
    t.top_term,
    t.top_term_score,
    t.top_term_percent_gain
FROM aggregated a
LEFT JOIN top_term_per_country t
    ON  a.week         = t.week
    AND a.country_code = t.country_code