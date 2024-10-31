-- This intermediate model unions the campaign performance data from Facebook Ads, LinkedIn Ads, and Google Ads.

WITH facebook_ads AS (
    SELECT
        date,
        campaign_name,
        impressions,
        clicks,
        spend,
        conv,
        conv_value,
        platform,
        loaded_at_time
    FROM {{ ref('int_facebook_ads__campaign_performance') }}
),

linkedin_ads AS (
    SELECT
        date,
        campaign_name,
        impressions,
        clicks,
        spend,
        conv,
        conv_value,
        platform,
        loaded_at_time
    FROM {{ ref('int_linkedin_ads__campaign_performance') }}
),

google_ads AS (
    SELECT
        date,
        campaign_name,
        impressions,
        clicks,
        spend,
        conv,
        conv_value,
        platform,
        loaded_at_time
    FROM {{ ref('int_google_ads__campaign_performance') }}
)

SELECT * FROM facebook_ads
UNION ALL
SELECT * FROM linkedin_ads
UNION ALL
SELECT * FROM google_ads