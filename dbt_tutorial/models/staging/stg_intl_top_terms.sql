WITH source AS (
    SELECT * FROM {{ source('google_trends', 'international_top_terms') }}
)

SELECT
    refresh_date,
    LOWER(term)                 AS term,
    UPPER(country_code)         AS country_code,
    country_name,
    UPPER(region_code)          AS region_code,
    region_name,
    week,
    score                       AS trend_score,
    rank                        AS trend_rank
FROM source
WHERE
    term IS NOT NULL
    AND country_code IS NOT NULL
    AND week IS NOT NULL