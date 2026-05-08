-- Joins international top terms with rising terms to get
-- both score and percent_gain per term per country per week

WITH top_terms AS (
    SELECT * FROM {{ ref('stg_intl_top_terms') }}
),

rising_terms AS (
    SELECT * FROM {{ ref('stg_intl_top_rising_terms') }}
),

joined AS (
    SELECT
        t.week,
        t.refresh_date,
        t.term,
        t.country_code,
        t.country_name,
        t.region_code,
        t.region_name,
        t.trend_score,
        t.trend_rank,
        r.percent_gain,

        -- Classify trend momentum
        CASE
            WHEN r.percent_gain >= 5000  THEN 'Breakout'
            WHEN r.percent_gain >= 1000  THEN 'Rising Fast'
            WHEN r.percent_gain >= 100   THEN 'Rising'
            WHEN r.percent_gain IS NULL  THEN 'Stable'
            ELSE 'Slow Rise'
        END                             AS trend_momentum,

        -- Classify score into High / Medium / Low
        CASE
            WHEN t.trend_score >= 75    THEN 'High'
            WHEN t.trend_score >= 40    THEN 'Medium'
            ELSE                             'Low'
        END                             AS trend_strength

    FROM top_terms t
    LEFT JOIN rising_terms r
        ON  t.term         = r.term
        AND t.country_code = r.country_code
        AND t.week         = r.week
        AND t.region_code  = r.region_code
)

SELECT
    *,
    -- Rank terms within each country per week
    ROW_NUMBER() OVER (
        PARTITION BY country_code, week
        ORDER BY trend_score DESC
    )                                   AS country_week_rank
FROM joined
