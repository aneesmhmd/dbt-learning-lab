-- Top 10 trending terms per US DMA region per week
-- Ready for US regional trends dashboard

{{
    config(
        unique_key=['term', 'dma_id', 'week'],
        incremental_strategy='insert_overwrite',
        partition_by={
            "field": "week",
            "data_type": "date",
            "granularity": "day"
        },
        cluster_by=['dma_id', 'term', 'trend_momentum']
    )
}}

WITH base AS (
    SELECT * FROM {{ ref('tfm_us_trends') }}

    {% if is_incremental()%}
        WHERE week > (SELECT MAX(week) FROM {{ this }})
    {% endif %}
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