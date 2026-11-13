select
    customer_id,
    full_name,
    country,
    city,
    segment,
    loyalty_tier,
    try_to_date(signup_date) as signup_date
from {{ source('raw', 'customers') }}
-- email is deliberately not selected: PII stays out of the analytics layer




