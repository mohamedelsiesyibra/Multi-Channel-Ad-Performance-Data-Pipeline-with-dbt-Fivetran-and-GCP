-- This intermediate model joins the LinkedIn Ads ad analytics data and campaign history data
-- on campaign_id to get campaign performance metrics including impressions, clicks, spend, conversions, and conversion values.

WITH ad_analytics AS (
    SELECT
        campaign_id,
        day AS date,
        clicks,
        impressions,
        cost_in_local_currency AS spend,
        external_website_conversions AS conv,
        conversion_value_in_local_currency AS conv_value,
        platform,
        loaded_at_time
    FROM {{ ref('stg_linkedin_ads__ad_analytics_by_campaign') }}
),

campaign_history AS (
    SELECT
        campaign_id,
        campaign_name
    FROM {{ ref('stg_linkedin_ads__campaign_history') }}
)

SELECT
    a.date,
    c.campaign_name,
    a.impressions,
    a.clicks,
    a.spend,
    a.conv,
    a.conv_value,
    a.platform,
    a.loaded_at_time
FROM ad_analytics a
LEFT JOIN campaign_history c
ON a.campaign_id = c.campaign_id