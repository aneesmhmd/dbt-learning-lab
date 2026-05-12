
WITH source AS (
    SELECT * FROM {{ source('google_trends', 'top_rising_terms') }}
)

SELECT
    refresh_date,
    LOWER(term)                 AS term,
    week,
    score                       AS trend_score,
    percent_gain,
    rank                        AS trend_rank,
    dma_name,
    dma_id
FROM source
WHERE
    term IS NOT NULL
    AND week IS NOT NULL