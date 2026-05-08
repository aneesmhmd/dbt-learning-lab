-- Joins US top terms with US rising terms
-- enriched with DMA region info and trend classification

WITH top_terms AS (
    SELECT * FROM {{ ref('stg_top_terms') }}
),

rising_terms AS (
    SELECT * FROM {{ ref('stg_top_rising_terms') }}
),

joined AS (
    SELECT
        t.week,
        t.refresh_date,
        t.term,
        t.dma_id,
        t.dma_name,
        t.trend_score,
        t.trend_rank,
        r.percent_gain,

        -- Classify trend momentum
        CASE
            WHEN r.percent_gain >= 5000  THEN 'Breakout'
            WHEN r.percent_gain >= 1000  THEN 'Rising Fast'
            WHEN r.percent_gain >= 100   THEN 'Rising'
            WHEN r.percent_gain IS NULL  THEN 'Stable'
            ELSE                              'Slow Rise'
        END                             AS trend_momentum,

        -- Classify score strength
        CASE
            WHEN t.trend_score >= 75    THEN 'High'
            WHEN t.trend_score >= 40    THEN 'Medium'
            ELSE                             'Low'
        END                             AS trend_strength

    FROM top_terms t
    LEFT JOIN rising_terms r
        ON  t.term   = r.term
        AND t.week   = r.week
        AND t.dma_id = r.dma_id
)

SELECT
    *,
    -- Rank terms within each DMA per week
    ROW_NUMBER() OVER (
        PARTITION BY dma_id, week
        ORDER BY trend_score DESC
    )                                   AS dma_week_rank
FROM joined