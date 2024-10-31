-- This staging model prepares the Google Ads campaign stats data for further analysis.
-- It selects and standardizes the necessary columns from the source table.

WITH source AS (
    SELECT
        _fivetran_id,
        date,
        customer_id,
        active_view_impressions,
        id AS campaign_id,
        active_view_measurability,
        active_view_measurable_cost_micros,
        active_view_measurable_impressions,
        active_view_viewability,
        ad_network_type,
        clicks,
        conversions,
        conversion_value,
        cost_micros,
        device,
        impressions,
        interactions,
        interaction_event_types,
        view_through_conversions,
        loaded_at_time,
        'Google Ads' AS platform
    FROM {{ source('google_ads', 'campaign_stats') }}
)

SELECT
    _fivetran_id,
    date,
    customer_id,
    active_view_impressions,
    campaign_id,
    active_view_measurability,
    active_view_measurable_cost_micros,
    active_view_measurable_impressions,
    active_view_viewability,
    ad_network_type,
    clicks,
    conversions,
    conversion_value,
    cost_micros,
    device,
    impressions,
    interactions,
    interaction_event_types,
    view_through_conversions,
    loaded_at_time,
    platform
FROM source