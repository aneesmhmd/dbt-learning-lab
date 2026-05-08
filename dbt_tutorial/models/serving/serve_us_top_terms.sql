-- Top 10 trending terms per US DMA region per week
-- Ready for US regional trends dashboard

WITH base AS (
    SELECT * FROM {{ ref('tfm_us_trends') }}
)

SELECT
    week,
    dma_id,
    dma_name,
    term,
    trend_score,
    trend_rank,
    percent_gain,
    trend_momentum,
    trend_strength,
    dma_week_rank,
    CURRENT_TIMESTAMP()             AS loaded_at
FROM base
WHERE dma_week_rank <= 10         -- top 10 terms per DMA per week