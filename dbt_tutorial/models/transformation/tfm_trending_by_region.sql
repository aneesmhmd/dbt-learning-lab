-- Ranks terms within each region per week
-- Identifies top terms at a regional level internationally

WITH base AS (
    SELECT * FROM {{ ref('stg_intl_top_terms') }}
),

regional_ranks AS (
    SELECT
        week,
        refresh_date,
        country_code,
        country_name,
        region_code,
        region_name,
        term,
        trend_score,
        trend_rank,

        -- Rank within region per week
        ROW_NUMBER() OVER (
            PARTITION BY region_code, week
            ORDER BY trend_score DESC
        )                               AS region_week_rank,

        -- Score relative to country average
        ROUND(
            trend_score - AVG(trend_score) OVER (
                PARTITION BY country_code, week
            ), 2
        )                               AS score_vs_country_avg

    FROM base
)

SELECT * FROM regional_ranks