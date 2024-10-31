-- This staging model prepares the LinkedIn Ads campaign history data for further analysis.
-- It selects and standardizes the necessary columns from the source table.

WITH source AS (
    SELECT
        id AS campaign_id,
        name AS campaign_name,
        last_modified_time,
        campaign_group_id,
        account_id,
        created_time,
        associated_entity,
        audience_expansion_enabled,
        cost_type,
        creative_selection,
        daily_budget_amount,
        daily_budget_currency_code,
        locale_country,
        locale_language,
        objective_type,
        offsite_delivery_enabled,
        run_schedule_start,
        run_schedule_end,
        type AS campaign_type,
        unit_cost_amount,
        unit_cost_currency_code,
        version_tag,
        optimization_target_type,
        status AS campaign_status,
        format AS campaign_format,
        'LinkedIn Ads' AS platform 
    FROM {{ source('linkedin_ads', 'campaign_history') }}
)

SELECT
    campaign_id,
    campaign_name,
    last_modified_time,
    campaign_group_id,
    account_id,
    created_time,
    associated_entity,
    audience_expansion_enabled,
    cost_type,
    creative_selection,
    daily_budget_amount,
    daily_budget_currency_code,
    locale_country,
    locale_language,
    objective_type,
    offsite_delivery_enabled,
    run_schedule_start,
    run_schedule_end,
    campaign_type,
    unit_cost_amount,
    unit_cost_currency_code,
    version_tag,
    optimization_target_type,
    campaign_status,
    campaign_format,
    platform 
FROM source