-- This staging model prepares the Google Ads campaign history data for further analysis.
-- It selects and standardizes the necessary columns from the source table.

WITH source AS (
    SELECT
        id AS campaign_id,
        updated_at,
        base_campaign_id,
        customer_id,
        ad_serving_optimization_status,
        advertising_channel_sub_type,
        advertising_channel_type,
        experiment_type,
        end_date,
        final_url_suffix,
        frequency_caps,
        name AS campaign_name,
        serving_status,
        start_date,
        status AS campaign_status,
        tracking_url_template,
        vanity_pharma_display_url_mode,
        vanity_pharma_text,
        optimization_score,
        payment_mode,
        video_brand_safety_suitability,
        'Google Ads' AS platform
    FROM {{ source('google_ads', 'campaign_history') }}
)

SELECT
    campaign_id,
    updated_at,
    base_campaign_id,
    customer_id,
    ad_serving_optimization_status,
    advertising_channel_sub_type,
    advertising_channel_type,
    experiment_type,
    end_date,
    final_url_suffix,
    frequency_caps,
    campaign_name,
    serving_status,
    start_date,
    campaign_status,
    tracking_url_template,
    vanity_pharma_display_url_mode,
    vanity_pharma_text,
    optimization_score,
    payment_mode,
    video_brand_safety_suitability,
    platform
FROM source