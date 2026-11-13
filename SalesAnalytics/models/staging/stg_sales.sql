-- Already typed, standardized and de-duplicated by SP_LOAD_SALES, so this layer
-- only renames and exposes it to dbt.
select
    sale_id,
    order_id,
    customer_id,
    store_id,
    product_id,
    order_date,
    quantity,
    unit_price,
    discount_pct,
    order_status,
    payment_method,
    promo_code,        -- NULL for 2025 rows (column did not exist)
    sales_channel,     -- NULL for 2025 rows
    gross_amount,
    net_amount,
    source_batch,
    loaded_at
from {{ source('curated', 'sales_clean') }}
