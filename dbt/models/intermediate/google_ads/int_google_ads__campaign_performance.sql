-- This intermediate model joins the Google Ads campaign stats data and campaign history data
-- on campaign_id to get campaign performance metrics including impressions, clicks, spend, conversions, and conversion values.

WITH campaign_stats AS (
    SELECT
        date,
        campaign_id,
        clicks,
        impressions,
        cost_micros / 1000000 AS spend,  -- Converting micros to standard currency
        conversions AS conv,
        conversion_value AS conv_value,
        platform,
        loaded_at_time
    FROM {{ ref('stg_google_ads__campaign_stats') }}
),

campaign_history AS (
    SELECT
        campaign_id,
        campaign_name
    FROM {{ ref('stg_google_ads__campaign_history') }}
)

SELECT
    s.date,
    h.campaign_name,
    s.impressions,
    s.clicks,
    s.spend,
    s.conv,
    s.conv_value,
    s.platform,
    s.loaded_at_time
FROM campaign_stats s
LEFT JOIN campaign_history h
ON s.campaign_id = h.campaign_id