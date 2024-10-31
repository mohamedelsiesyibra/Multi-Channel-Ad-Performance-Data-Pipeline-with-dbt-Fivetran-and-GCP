-- This intermediate model joins the Facebook Ads basic ad action value data and basic all levels data
-- on date and ad_id to get campaign performance metrics including impressions, clicks, spend, conversions, and conversion values.

WITH basic_ad_action_value AS (
    SELECT
        date,
        ad_id,
        action AS conv,
        action_values AS conv_value
    FROM {{ ref('stg_facebook_ads__basic_ad_action_value') }}
),

basic_all_levels AS (
    SELECT
        date AS all_levels_date,
        ad_id AS all_levels_ad_id,
        campaign_name,
        impressions,
        inline_link_clicks AS clicks,
        spend,
        platform,
        loaded_at_time
    FROM {{ ref('stg_facebook_ads__basic_all_levels') }}
)

SELECT
    b.all_levels_date AS date,
    b.campaign_name,
    b.impressions,
    b.clicks,
    b.spend,
    a.conv,
    a.conv_value,
    b.platform,
    b.loaded_at_time
FROM basic_all_levels b
LEFT JOIN basic_ad_action_value a
ON b.all_levels_date = a.date AND b.all_levels_ad_id = a.ad_id