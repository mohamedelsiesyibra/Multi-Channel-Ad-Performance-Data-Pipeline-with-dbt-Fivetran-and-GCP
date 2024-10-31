-- Ensure that the spend column is never negative
select
    date,
    campaign_name,
    platform,
    spend
from {{ ref('marts_marketing__final_campaign_performance') }}
where spend < 0