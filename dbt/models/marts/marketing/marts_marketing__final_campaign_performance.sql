-- This final model aggregates the campaign performance data from Facebook Ads, LinkedIn Ads, and Google Ads.
-- It is designed to be incremental to optimize performance.

{{ config(
    materialized = "incremental",
    unique_key = "campaign_id_date_platform",
    on_schema_change = 'append_new_columns',
    partition_by = {
      "field": "date",
      "data_type": "date"
    },
    cluster_by = ['date']
) }}

WITH blended_ads AS (
    SELECT
        date,
        campaign_name,
        platform,
        SUM(impressions) AS impressions,
        SUM(clicks) AS clicks,
        SUM(spend) AS spend,
        SUM(conv) AS conv,
        SUM(conv_value) AS conv_value,
        MAX(loaded_at_time) AS loaded_at_time
    FROM {{ ref('int_blended_ads__campaign_performance') }}
    GROUP BY
        date,
        campaign_name,
        platform
)

SELECT
    date,
    campaign_name,
    platform,
    impressions,
    clicks,
    spend,
    conv,
    conv_value,
    CASE WHEN clicks > 0 THEN spend / clicks ELSE 0 END AS cpc,
    CASE WHEN impressions > 0 THEN (spend / impressions) * 1000 ELSE 0 END AS cpm,  
    CASE WHEN conv > 0 THEN spend / conv ELSE 0 END AS cost_per_conv,
    CASE WHEN spend > 0 THEN conv_value / spend ELSE 0 END AS roas,
    CONCAT(campaign_name, '_', date, '_', platform) AS campaign_id_date_platform,
    loaded_at_time
FROM blended_ads

{% if is_incremental() %}

WHERE loaded_at_time >= (SELECT MAX(loaded_at_time) FROM {{ this }})

{% endif %}