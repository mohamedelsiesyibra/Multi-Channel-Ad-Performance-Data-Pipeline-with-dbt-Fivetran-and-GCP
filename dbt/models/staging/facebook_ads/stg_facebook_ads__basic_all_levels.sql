-- This staging model prepares the Facebook Ads basic all levels data for further analysis.
-- It selects and standardizes the necessary columns from the source table.

WITH source AS (
    SELECT
        _fivetran_id,
        date,
        account_id,
        ad_id,
        actions,
        ad_name,
        adset_name,
        campaign_name,
        cost_per_action_type,
        cost_per_inline_link_click,
        cpc,
        cpm,
        ctr,
        frequency,
        impressions,
        inline_link_click_ctr,
        inline_link_clicks,
        reach,
        spend,
        loaded_at_time,
        'Facebook Ads' AS platform
    FROM {{ source('facebook_ads', 'basic_all_levels') }}
)

SELECT
    _fivetran_id,
    date,
    account_id,
    ad_id,
    actions,
    ad_name,
    adset_name,
    campaign_name,
    cost_per_action_type,
    cost_per_inline_link_click,
    cpc,
    cpm,
    ctr,
    frequency,
    impressions,
    inline_link_click_ctr,
    inline_link_clicks,
    reach,
    spend,
    loaded_at_time,
    platform
FROM source