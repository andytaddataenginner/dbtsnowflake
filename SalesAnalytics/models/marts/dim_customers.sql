-- Full SCD2 history of customers. Filter is_current for today's view.
select
    dbt_scd_id                  as customer_key,
    customer_id,
    full_name,
    country,
    city,
    segment,
    loyalty_tier,
    signup_date,
    dbt_valid_from              as valid_from,
    dbt_valid_to                as valid_to,
    (dbt_valid_to is null)      as is_current
from {{ ref('snap_customers') }}
