select
    store_id,
    store_name,
    region,
    country,
    store_type
from {{ ref('stg_stores') }}
