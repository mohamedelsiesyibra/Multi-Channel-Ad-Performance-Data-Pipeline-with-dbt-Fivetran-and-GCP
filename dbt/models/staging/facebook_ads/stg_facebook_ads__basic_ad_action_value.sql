-- This staging model prepares the Facebook Ads basic ad action value data for further analysis.
-- It selects and standardizes the necessary columns from the source table.

WITH source AS (
    SELECT
        _fivetran_id,
        date,
        account_id,
        ad_id,
        action,
        action_values,
        ad_name,
        adset_name,
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
        'Facebook Ads' AS platform
    FROM {{ source('facebook_ads', 'basic_ad_action_value') }}
)

SELECT
    _fivetran_id,
    date,
    account_id,
    ad_id,
    action,
    action_values,
    ad_name,
    adset_name,
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
    platform
FROM source